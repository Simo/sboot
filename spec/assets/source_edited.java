package tex.software.prova.business.dtos;

import tex.software.prova.persistence.entities.Actor;

public class ActorDTO {

    
    private Integer id;
    
    private String name;
    

    public ActorDTO(){}

	public ActorDTO(Actor entity){
	    this.id = entity.getId();
	    this.name = entity.getName();
	}

    /* Un commento */
    public Actor convert() {
      Actor entity = new Actor();
						entity.setId(this.id);
			entity.setName(this.name);
    	return entity;
    }

  public Integer getId() {
		return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }
  public String getName() {
		return name;
  }

  public void setName(String name) {
    this.name = name;
  }
  
  private void metodoPrivato() {
  }

}
