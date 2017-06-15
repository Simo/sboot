package it.insiel.gcs.persistence.entities;

import javax.persistence.*;

@Entity
@Table(name = "PERSONA")
public class Persona {

  @Id
  @GeneratedValue(strategy= GenerationType.AUTO)
//  @GeneratedValue(strategy= GenerationType.AUTO, generator="persona_seq_gen")
//  @SequenceGenerator(name="persona_seq_gen", sequenceName="SEQ_T_PERSONA_ID")
  @Column(name = "PESONA_ID")
  private Integer pesona_id;

          @Column(name = "NOME")
  private String nome;
        @Column(name = "COGNOME")
  private String cognome;
    
  public Integer getPesonaId() {
    return pesonaId;
  }

  public void setPesonaId(Integer pesonaId) {
    this.pesonaId = pesonaId;
  }
  public String getNome() {
    return nome;
  }

  public void setNome(String nome) {
    this.nome = nome;
  }
  public String getCognome() {
    return cognome;
  }

  public void setCognome(String cognome) {
    this.cognome = cognome;
  }
}
