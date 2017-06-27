package it.insiel.gcs.web.controllers;

import it.insiel.gcs.business.dtos.PersonaDTO;
import it.insiel.gcs.business.services.PersonaService;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.web.context.WebApplicationContext;

import java.util.ArrayList;
import java.util.List;

@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
public class PersonaControllerTest {

    @Autowired
    private MockMvc mockMvc;
    @MockBean
    private PersonaService mockService;

    private Integer primary_key;

    @Autowired
    private WebApplicationContext webApplicationContext;

    private List<PersonaDTO> lista = new ArrayList<PersonaDTO>();

    PersonaDTO persona1;

    @Before
    public void setUp() throws Exception {
        this.primary_key = new Integer(1);
        persona1 = new PersonaDTO();
        persona1.setPersonaId(primary_key);
        persona1.setNome("testo");
        persona1.setCognome("testo");
        persona1.setDataNascita("31/12/2000");
        persona1.setCasa2(new Integer(10));
        lista.add(persona1);
    }

    @Test
    public void index() throws Exception {
        assertThat(this.mockService).isNotNull();
        when(mockService.trovaTutti()).thenReturn(lista);
        this.mockMvc.perform(MockMvcRequestBuilders.get("/persone").accept(MediaType.TEXT_HTML_VALUE)
                .header("Access-Control-Request-Method", "GET")
                .header("Origin", "http://localhost:8080"))
                .andExpect(status().isOk())
            .andExpect(view().name("persone/index"))
            .andExpect(MockMvcResultMatchers.model().attributeExists("persone"))
            .andExpect(MockMvcResultMatchers.model().attribute("persone", lista))
            .andDo(print());
    }

    @Test
    public void dettaglio() throws Exception {
        assertThat(this.mockService).isNotNull();
        when(mockService.trova(primary_key)).thenReturn(this.persona1);
        this.mockMvc.perform(MockMvcRequestBuilders.get("/persone/"+persona1.getPersonaId())
                .header("Access-Control-Request-Method", "GET")
                .header("Origin", "http://localhost:8080")
                .accept(MediaType.TEXT_HTML_VALUE))
                .andExpect(status().isOk())
            .andExpect(view().name("persone/show"))
            .andExpect(MockMvcResultMatchers.model().attributeExists("persona"))
            .andExpect(MockMvcResultMatchers.model().attribute("persona", persona1))
            .andDo(print());
    }

    @Test
    public void nuovo() throws Exception {
        assertThat(this.mockService).isNotNull();
        this.mockMvc.perform(MockMvcRequestBuilders.get("/persone/new")
                .header("Access-Control-Request-Method", "GET")
                .header("Origin", "http://localhost:8080")
                .accept(MediaType.TEXT_HTML_VALUE))
            .andExpect(status().isOk())
            .andExpect(view().name("persone/new"))
            .andExpect(MockMvcResultMatchers.model().attributeExists("persona"))
            .andDo(print());
    }

    @Test
    public void modifica() throws Exception {
        assertThat(this.mockService).isNotNull();
        when(mockService.trova(primary_key)).thenReturn(this.persona1);
        this.mockMvc.perform(MockMvcRequestBuilders.get("/persone/"+persona1.getPersonaId()+"/edit")
                .header("Access-Control-Request-Method", "GET")
                .header("Origin", "http://localhost:8080")
                .accept(MediaType.TEXT_HTML_VALUE))
                .andExpect(status().isOk())
            .andExpect(view().name("persone/edit"))
            .andExpect(MockMvcResultMatchers.model().attributeExists("persona"))
            .andExpect(MockMvcResultMatchers.model().attribute("persona", persona1))
            .andDo(print());
    }

    @Test
    public void salvaPost() throws Exception {
        assertThat(this.mockService).isNotNull();

        PersonaDTO personaNew = new PersonaDTO();
        personaNew.setPersonaId(primary_key);
        personaNew.setNome("testo");
        personaNew.setCognome("testo");
        personaNew.setDataNascita("31/12/2000");
        personaNew.setCasa2(new Integer(10));
        PersonaDTO personaNew2 = new PersonaDTO();
        personaNew2.setPersonaId(primary_key);
        personaNew2.setNome("testo");
        personaNew2.setCognome("testo");
        personaNew2.setDataNascita("31/12/2000");
        personaNew2.setCasa2(new Integer(10));

        when(mockService.salva(any(PersonaDTO.class))).thenReturn(personaNew2);
        this.mockMvc.perform(MockMvcRequestBuilders.post("/persone")
                .header("Access-Control-Request-Method", "POST")
                .header("Origin", "http://localhost:8080")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .param("persona_id",personaNew.getPersonaId().toString())
                .param("nome",personaNew.getNome().toString())
                .param("cognome",personaNew.getCognome().toString())
                .param("data_nascita",personaNew.getDataNascita().toString())
                .param("casa2",personaNew.getCasa2().toString())
            )
            .andExpect(status().is3xxRedirection())
            .andExpect(MockMvcResultMatchers.redirectedUrl("/persone/"+personaNew2.getPersonaId()))
            .andDo(print());
    }

    @Test
    public void salvaPut() throws Exception {
        assertThat(this.mockService).isNotNull();

        PersonaDTO personaUpdate = new PersonaDTO();
        personaUpdate.setPersonaId(primary_key);
        personaUpdate.setNome("testo");
        personaUpdate.setCognome("testo");
        personaUpdate.setDataNascita("31/12/2000");
        personaUpdate.setCasa2(new Integer(10));

        when(mockService.salva(any(PersonaDTO.class))).thenReturn(personaUpdate);
        this.mockMvc.perform(MockMvcRequestBuilders.put("/persone/"+personaUpdate.getPersonaId())
                .header("Access-Control-Request-Method", "PUT")
                .header("Origin", "http://localhost:8080")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .param("persona_id",personaUpdate.getPersonaId().toString())
                .param("nome",personaUpdate.getNome().toString())
                .param("cognome",personaUpdate.getCognome().toString())
                .param("data_nascita",personaUpdate.getDataNascita().toString())
                .param("casa2",personaUpdate.getCasa2().toString())
            )
            .andExpect(status().is3xxRedirection())
            .andExpect(MockMvcResultMatchers.redirectedUrl("/persone/"+personaUpdate.getPersonaId()))
            .andDo(print());
    }

    @Test
    public void deleteRest() throws Exception {
        assertThat(this.mockService).isNotNull();
        
        PersonaDTO personaDelete = new PersonaDTO();

        personaDelete.setPersonaId(primary_key);
        personaDelete.setNome("testo");
        personaDelete.setCognome("testo");
        personaDelete.setDataNascita("31/12/2000");
        personaDelete.setCasa2(new Integer(10));

        when(mockService.cancella(personaDelete.getPersonaId())).thenReturn(1L);
        this.mockMvc.perform(MockMvcRequestBuilders.delete("/persone/"+personaDelete.getPersonaId())
                .header("Access-Control-Request-Method", "DELETE")
                .header("Origin", "http://localhost:8080"))
            .andExpect(status().is3xxRedirection())
            .andExpect(MockMvcResultMatchers.redirectedUrl("/persone"))
            .andDo(print());
    }

    @Test
    public void delete() throws Exception {
        assertThat(this.mockService).isNotNull();

        PersonaDTO personaDelete = new PersonaDTO();
        personaDelete.setPersonaId(primary_key);
        personaDelete.setNome("testo");
        personaDelete.setCognome("testo");
        personaDelete.setDataNascita("31/12/2000");
        personaDelete.setCasa2(new Integer(10));

        when(mockService.cancella(personaDelete.getPersonaId())).thenReturn(1L);
        this.mockMvc.perform(MockMvcRequestBuilders.get("/persone/"+personaDelete.getPersonaId()+"/delete")
                .header("Access-Control-Request-Method", "GET")
                .header("Origin", "http://localhost:8080"))
            .andExpect(status().is3xxRedirection())
            .andExpect(MockMvcResultMatchers.redirectedUrl("/persone"))
            .andDo(print());
    }
}
