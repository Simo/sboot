package it.insiel.gcs.progetto.business.dtos;

import it.insiel.gcs.progetto.persistence.entities.Casa;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "Casa", description = "Un oggetto Casa")
public class CasaDTO {

    
				@ApiModelProperty(value = "Identificativo univoco per un entita' Casa")
		private Long id;
		    
				@ApiModelProperty(value = "indirizzo di Casa")
    private String indirizzo;
		    
				@ApiModelProperty(value = "civico di Casa")
    private Long civico;
		    

    public CasaDTO(){}

    public CasaDTO(Casa entity){
						    this.id = entity.getId();
		    		    this.indirizzo = entity.getIndirizzo();
		    		    this.civico = entity.getCivico();
		        }

    public Casa convert(){
        Casa entity = new Casa();
						    entity.setId(this.id);
		    		    entity.setIndirizzo(this.indirizzo);
		    		    entity.setCivico(this.civico);
		            return entity;
    }

        public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

		    public String getIndirizzo() {
        return indirizzo;
    }

    public void setIndirizzo(String indirizzo) {
        this.indirizzo = indirizzo;
    }

		    public Long getCivico() {
        return civico;
    }

    public void setCivico(Long civico) {
        this.civico = civico;
    }

		}
