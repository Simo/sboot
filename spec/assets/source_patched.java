package tex.software.prova.business.dtos;

import tex.software.prova.persistence.entities.Actor;

public class ActorDTO {

    
    private Integer actorId;
    
    private String name;
    
    private Integer age;
    

    public ActorDTO(){}

	public ActorDTO(Actor entity){
	    this.actorId = entity.getActorId();
	    this.name = entity.getName();
								this.age = entity.getAge();
	}

    /* Un commento */
    public Actor convert() {
      Actor entity = new Actor();
						entity.setActorId(this.actorId);
			entity.setName(this.name);
			entity.setAge(this.age);
    	return entity;
    }

  public Integer getActorId() {
		return actorId;
  }

  public void setActorId(Integer actorId) {
    this.actorId = actorId;
  }
  public String getName() {
		return name;
  }

  public void setName(String name) {
    this.name = name;
  }
  public Integer getAge() {
		return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }
  
  private void metodoPrivato() {
  }

}
