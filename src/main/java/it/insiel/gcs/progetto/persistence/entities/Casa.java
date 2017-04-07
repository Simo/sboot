package it.insiel.gcs.progetto.persistence.entities;

import javax.persistence.*;

@Entity
@Table(name = "T_CASA")
public class Casa {

	@Id
	@GeneratedValue(strategy= GenerationType.AUTO, generator="casa_seq_gen")
	@SequenceGenerator(name="casa_seq_gen", sequenceName="SEQ_T_CASA_ID")
	@Column(name = "ID")
	private Long id;

							@Column(name = "INDIRIZZO")
	private String indirizzo;
						@Column(name = "CIVICO")
	private Long civico;
			
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