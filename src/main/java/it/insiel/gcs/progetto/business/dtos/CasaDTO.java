package it.insiel.gcs.progetto.business.dtos;

import it.insiel.gcs.progetto.persistence.entities.Casa;

public class CasaDTO {

    private Long id;
    
    private Long id;
    
    private Long indirizzo civico;
    

    public CasaDTO(){}

    public CasaDTO(Casa entity){
        this.id = entity.getId();
						    this.id = entity.getId();
		    		    this.indirizzo civico = entity.getIndirizzo civico();
		        }

    public Casa convert(){
        Casa entity = new Casa();
        entity.setId(this.id);
						    entity.setId(this.id);
		    		    entity.setIndirizzo civico(this.indirizzo civico);
		            return entity;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

        public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

		    public Long getIndirizzo civico() {
        return indirizzo civico;
    }

    public void setIndirizzo civico(Long indirizzo civico) {
        this.indirizzo civico = indirizzo civico;
    }

		}
