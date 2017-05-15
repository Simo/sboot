package it.insiel.gcs.progetto.web.controllers;

import it.insiel.gcs.progetto.business.dtos.CasaDTO;
import it.insiel.gcs.progetto.business.services.CasaService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
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

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
public class CasaControllerTest {

@Autowired
private MockMvc mockMvc;
@MockBean
private CasaService mockService;
@Autowired
private WebApplicationContext webApplicationContext;

private List<CasaDTO> lista = new ArrayList<CasaDTO>();

  CasaDTO casa1;

  @Before
  public void setUp() throws Exception {
  casa1 = new CasaDTO();
  casa1.setId(1L);
        casa1.setId(1L);
        casa1.setIndirizzo("stringa di testo");
        casa1.setCivico(1L);
    lista.add(casa1);
  }

  @Test
  public void index() throws Exception {
  assertThat(this.mockService).isNotNull();
  when(mockService.trovaTutti()).thenReturn(lista);
  this.mockMvc.perform(MockMvcRequestBuilders.get("/casa").accept(MediaType.TEXT_HTML_VALUE))
  .andExpect(status().isOk())
  .andExpect(view().name("casa/index"))
  .andExpect(MockMvcResultMatchers.model().attributeExists("casaLista"))
  .andExpect(MockMvcResultMatchers.model().attribute("casaLista", lista))
  .andDo(print());
  }

  @Test
  public void dettaglio() throws Exception {
  assertThat(this.mockService).isNotNull();
  when(mockService.trova(1L)).thenReturn(this.casa1);
  this.mockMvc.perform(MockMvcRequestBuilders.get("/casa/1").accept(MediaType.TEXT_HTML_VALUE))
  .andExpect(status().isOk())
  .andExpect(view().name("casa/dettaglio"))
  .andExpect(MockMvcResultMatchers.model().attributeExists("casa"))
  .andExpect(MockMvcResultMatchers.model().attribute("casa", casa1))
  .andDo(print());
  }

  @Test
  public void nuovo() throws Exception {
  assertThat(this.mockService).isNotNull();
  this.mockMvc.perform(MockMvcRequestBuilders.get("/casa/new").accept(MediaType.TEXT_HTML_VALUE))
  .andExpect(status().isOk())
  .andExpect(view().name("casa/nuovo"))
  .andExpect(MockMvcResultMatchers.model().attributeExists("casa"))
  .andDo(print());
  }

  @Test
  public void modifica() throws Exception {
  assertThat(this.mockService).isNotNull();
  when(mockService.trova(1L)).thenReturn(this.casa1);
  this.mockMvc.perform(MockMvcRequestBuilders.get("/casa/1/edit").accept(MediaType.TEXT_HTML_VALUE))
  .andExpect(status().isOk())
  .andExpect(view().name("casa/modifica"))
  .andExpect(MockMvcResultMatchers.model().attributeExists("casa"))
  .andExpect(MockMvcResultMatchers.model().attribute("casa", casa1))
  .andDo(print());
  }

  @Test
  public void salvaPost() throws Exception {
  assertThat(this.mockService).isNotNull();
  CasaDTO casaNew = new CasaDTO();
        casaNew.setId(1L);
        casaNew.setIndirizzo("stringa di testo");
        casaNew.setCivico(1L);
    CasaDTO casaNew2 = new CasaDTO();
  casaNew2.setId(2L);
        casaNew2.setId(1L);
        casaNew2.setIndirizzo("stringa di testo");
        casaNew2.setCivico(1L);
    when(mockService.salva(any(CasaDTO.class))).thenReturn(casaNew2);
  this.mockMvc.perform(MockMvcRequestBuilders.post("/casa").contentType(MediaType.APPLICATION_FORM_URLENCODED_VALUE)
  .param("id","").param("indirizzo",casaNew.getIndirizzo()).param("civico",casaNew.getCivico().toString()))
  .andExpect(status().is3xxRedirection())
  .andExpect(MockMvcResultMatchers.redirectedUrl("/casa/"+casaNew2.getId()))
  .andDo(print());
  }

  @Test
  public void salvaPut() throws Exception {
  assertThat(this.mockService).isNotNull();
  CasaDTO casaUpdate = new CasaDTO();
  casaUpdate.setId(1L);
        casaUpdate.setId(1L);
        casaUpdate.setIndirizzo("stringa di testo");
        casaUpdate.setCivico(1L);
    when(mockService.salva(any(CasaDTO.class))).thenReturn(casaUpdate);
  this.mockMvc.perform(MockMvcRequestBuilders.put("/casa/"+casaUpdate.getId()).contentType(MediaType.APPLICATION_FORM_URLENCODED_VALUE)
  .param("id",casaUpdate.getId().toString()).param("indirizzo",casaUpdate.getIndirizzo()).param("civico",casaUpdate.getCivico().toString()))
  .andExpect(status().is3xxRedirection())
  .andExpect(MockMvcResultMatchers.redirectedUrl("/casa/"+casaUpdate.getId()))
  .andDo(print());
  }

  @Test
  public void deleteRest() throws Exception {
  assertThat(this.mockService).isNotNull();
  CasaDTO casaDelete = new CasaDTO();
  casaDelete.setId(1L);
        casaDelete.setId(1L);
        casaDelete.setIndirizzo("stringa di testo");
        casaDelete.setCivico(1L);
    when(mockService.cancella(casaDelete.getId())).thenReturn(1L);
  this.mockMvc.perform(MockMvcRequestBuilders.delete("/casa/"+casaDelete.getId()))
  .andExpect(status().is3xxRedirection())
  .andExpect(MockMvcResultMatchers.redirectedUrl("/casa"))
  .andDo(print());
  }

  @Test
  public void delete() throws Exception {
  assertThat(this.mockService).isNotNull();
  CasaDTO casaDelete = new CasaDTO();
  casaDelete.setId(1L);
        casaDelete.setId(1L);
        casaDelete.setIndirizzo("stringa di testo");
        casaDelete.setCivico(1L);
    when(mockService.cancella(casaDelete.getId())).thenReturn(1L);
  this.mockMvc.perform(MockMvcRequestBuilders.get("/casa/"+casaDelete.getId()+"/delete"))
  .andExpect(status().is3xxRedirection())
  .andExpect(MockMvcResultMatchers.redirectedUrl("/casa"))
  .andDo(print());
  }
  }
