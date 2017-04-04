package it.insiel.gcs.progetto.business.services;

import it.insiel.gcs.progetto.business.dtos.CasaDTO;

import java.util.List;

public interface CasaService {

    List<CasaDTO> trovaTutti();

    CasaDTO trova(Long id);

    CasaDTO salva(CasaDTO model);

    Long cancella(Long id);

}
