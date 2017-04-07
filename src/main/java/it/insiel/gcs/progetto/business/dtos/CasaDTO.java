package it.insiel.gcs.progetto.business.dtos;

import it.insiel.gcs.progetto.persistence.entities.Casa;

public class CasaDTO {

    
    private Long id;
    
    private String indirizzo;
    
    private Long civico;
    

    public CasaDTO(){}

	public CasaDTO(Casa entity){
						this.Long = entity.getId();
								this.String = entity.getIndirizzo();
								this.Long = entity.getCivico();
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
