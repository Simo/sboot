package it.insiel.gcs.progetto.persistence.entities;

import javax.persistence.*;

@Entity
@Table(name = "T_CASA")
public class Casa {

    private Long id;
									@Id
				@GeneratedValue(strategy= GenerationType.AUTO, generator="casa_seq_gen")
				@SequenceGenerator(name="casa_seq_gen", sequenceName="SEQ_T_CASA_ID")
				@Column(name = "ID")
				private Long id;
			    							@Column(name = "INDIRIZZO CIVICO")
				private Long indirizzo civico;
			    
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