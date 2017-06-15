package it.insiel.gcs.progetto.persistence.entities;

import javax.persistence.*;

@Entity
@Table(name = "CASA")
public class Casa {

  @Id
  @GeneratedValue(strategy= GenerationType.AUTO)
//  @GeneratedValue(strategy= GenerationType.AUTO, generator="casa_seq_gen")
//  @SequenceGenerator(name="casa_seq_gen", sequenceName="SEQ_T_CASA_ID")
  @Column(name = "CASA_ID")
  private Integer casa_id;

          @Column(name = "INDIRIZZO")
  private String indirizzo;

  @OneToMany(mappedBy="casa", targetEntity=Persona.class, fetch=FetchType.LAZY)
  private List<Persona> persone;
  
  public List<Persona> getPersone() {
    return persona;
  }

  public void addPersona(Persona persona) {
    this.persone.add(persona);
    
    if (persona.getXYZ() != this) {
        persona.setXYZ(this);
    }
  }

    
  public Integer getCasaId() {
    return casaId;
  }

  public void setCasaId(Integer casaId) {
    this.casaId = casaId;
  }
  public String getIndirizzo() {
    return indirizzo;
  }

  public void setIndirizzo(String indirizzo) {
    this.indirizzo = indirizzo;
  }
}
