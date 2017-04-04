package it.insiel.gcs.progetto.business.services.impl;

import it.insiel.gcs.progetto.business.dtos.CasaDTO;
import it.insiel.gcs.progetto.business.exceptions.CasaEntityNotFoundException;
import it.insiel.gcs.progetto.business.services.CasaService;
import it.insiel.gcs.progetto.persistence.entities.Casa;
import it.insiel.gcs.progetto.persistence.repositories.CasaRepository;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

@RunWith(SpringRunner.class)
public class CasaServiceImplTest {

    @MockBean
    private CasaRepository repository;

    private CasaService service;

    private List<Casa> lista = new ArrayList<Casa>();

    Casa casa1;

    @Before
    public void setUp() throws Exception {
        this.service = new CasaServiceImpl(this.repository);
        casa1 = new Casa();
        casa1.setId(1L);
        casa1.setIndirizzo("via pazza");
        casa1.setCivico(34L);
        lista.add(casa1);
    }

    @Test
    public void trovaTutti() throws Exception {
        assertThat(this.repository).isNotNull();
        when(this.repository.findAll()).thenReturn(this.lista);
        assertThat(this.service.trovaTutti().size()).isEqualTo(1);
        assertThat(this.service.trovaTutti().get(0)).isInstanceOf(CasaDTO.class);
    }

    @Test
    public void trova() throws Exception {
        assertThat(this.repository).isNotNull();
        when(this.repository.findOne(1L)).thenReturn(this.casa1);
        assertThat(this.service.trova(1L)).isInstanceOf(CasaDTO.class);
    }

    @Test(expected = CasaEntityNotFoundException.class)
    public void nonTrova() throws Exception {
        assertThat(this.repository).isNotNull();
        when(this.repository.findOne(1L)).thenReturn(null);
        assertThat(this.service.trova(1L));
    }


    @Test
    public void salva() throws Exception {
        assertThat(this.repository).isNotNull();
        CasaDTO newCasaDto = new CasaDTO(casa1);
        when(this.repository.save(any(Casa.class))).thenReturn(this.casa1);
        assertThat(this.service.salva(newCasaDto).getId()).isEqualTo(1L);
    }

    @Test
    public void cancella() throws Exception {
        assertThat(this.repository).isNotNull();
        CasaDTO casaDto = new CasaDTO(casa1);
        when(this.repository.deleteById(1L)).thenReturn(1L);
        assertThat(this.service.cancella(casaDto.getId())).isEqualTo(1L);
    }
}
