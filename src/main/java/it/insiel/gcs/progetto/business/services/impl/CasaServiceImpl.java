package it.insiel.gcs.progetto.business.services.impl;

import it.insiel.gcs.progetto.business.dtos.CasaDTO;
import it.insiel.gcs.progetto.business.services.CasaService;
import it.insiel.gcs.progetto.business.exceptions.CasaEntityNotFoundException;
import it.insiel.gcs.progetto.persistence.entities.Casa;
import it.insiel.gcs.progetto.persistence.repositories.CasaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class CasaServiceImpl implements CasaService {

    private CasaRepository repository;

		@Autowired
		public CasaServiceImpl(CasaRepository repo){
			this.repository = repo;
		}

    @Override
    public List<CasaDTO> trovaTutti() {
        List<Casa> source = repository.findAll();
        List<CasaDTO> dtos = new ArrayList<CasaDTO>();
        for (Casa entity : source){
            CasaDTO dto = new CasaDTO(entity);
            dtos.add(dto);
        }
        return dtos;
    }

    @Override
    public CasaDTO trova(Long id) {
        return new CasaDTO(this.findOneSafe(id));
    }

    @Override
    public CasaDTO salva(CasaDTO model) {
        return new CasaDTO(repository.save(model.convert()));
    }

    @Override
    @Transactional
    public Long cancella(Long id) {
        return repository.deleteById(id);
    }

    private Casa findOneSafe(Long id) {
        Casa entity = repository.findOne(id);
        if (entity == null) {
            throw new CasaEntityNotFoundException(Casa.class.toString(),id);
        } else {
            return entity;
        }
    }
}
