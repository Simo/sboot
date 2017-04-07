package it.insiel.gcs.progetto.persistence.repositories;

import it.insiel.gcs.progetto.persistence.entities.Casa;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CasaRepository extends JpaRepository<Casa,String> {

    Long deleteByIndirizzo(String indirizzo);

}