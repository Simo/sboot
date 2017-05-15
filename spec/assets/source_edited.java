package it.insiel.myproject;

/* commento di classe */
public class WriterTest {
    @Annotazione
    private int id; /* commento campo */

    @Override
    @Nonnull /* inserimento in mezzo */
    public String toString() {
        return "<<WriterTest>>";
    }

    /* nuovo metodo */
    public int getId() {
        return id;
    }
}
