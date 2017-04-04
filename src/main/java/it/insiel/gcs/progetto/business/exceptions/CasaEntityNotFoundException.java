package it.insiel.gcs.progetto.business.exceptions;

public class CasaEntityNotFoundException extends RuntimeException {
    private Long id;
    private String klass;

    public CasaEntityNotFoundException(String klass, Long id) {
        this.klass = klass;
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public String getKlass(){
        return klass;
    }

    @Override
    public String getMessage() {
        return "" + klass + " entity with ID '" + id + "' not found";
    }
}
