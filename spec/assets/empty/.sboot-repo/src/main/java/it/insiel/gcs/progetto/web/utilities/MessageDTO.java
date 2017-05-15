package it.insiel.gcs.progetto.web.utilities.messages;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "Message", description = "Un messaggio con informazioni supplementari sul fallimento dell'operazione")
public class MessageDTO {

    @ApiModelProperty(value = "Il messaggio che viene comunicato", readOnly = true)
    private String message;

    public MessageDTO(String message) {
        this.message = message;
    }

    public MessageDTO() {
    }

    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }
}
