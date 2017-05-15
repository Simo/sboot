package it.insiel.gcs.progetto.web.controllers.api;

import java.util.List;
import java.util.Locale;
import javax.validation.Valid;
import it.insiel.gcs.progetto.web.utilities.MessageDTO;
import it.insiel.gcs.progetto.business.dtos.CasaDTO;
import it.insiel.gcs.progetto.business.exceptions.CasaEntityNotFoundException;
import it.insiel.gcs.progetto.business.services.CasaService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/casa")
@Api(value="/api/casa",tags={"Casa Endpoint"})
public class CasaController {

    @Autowired
    private CasaService service;
    @Autowired
    private MessageSource messageSource;

    @RequestMapping(method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation(value = "Trova tutte le Casa", notes = "Recupera la lista di tutte le Casa", response = CasaDTO[].class)
    @ApiResponses({
        @ApiResponse(code = 200, message = "Success", response = CasaDTO[].class)
    })
    public List<CasaDTO> findAll() {
        return service.trovaTutti();
    }

    @RequestMapping(method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation(value = "Crea nuova Casa", notes = "Crea una nuova Casa", response = CasaDTO.class)
    @ApiResponses({
        @ApiResponse(code = 200, message = "Success", response = CasaDTO.class),
        @ApiResponse(code = 400, message = "Bad request", response = MessageDTO.class)
    })
    public CasaDTO create(
            @ApiParam(required = true, name = "casa", value = "New casa")
            @Valid @RequestBody CasaDTO dto) {
        return service.salva(dto);
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.PUT, consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation(value = "Esegui update Casa", notes = "Aggiorna una Casa esistente", response = CasaDTO.class)
    @ApiResponses({
        @ApiResponse(code = 200, message = "Success", response = CasaDTO.class),
        @ApiResponse(code = 400, message = "Bad request", response = MessageDTO.class),
        @ApiResponse(code = 404, message = "Not found", response = MessageDTO.class)
    })
    public CasaDTO update(
            @ApiParam(required = true, name = "casa", value = "")
            @Valid @RequestBody CasaDTO dto) {
        return service.salva(dto);
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ApiOperation(value = "Visualizza Casa", notes = "Visualizza una Casa esistente", response = CasaDTO.class)
    @ApiResponses({
        @ApiResponse(code = 200, message = "Success", response = CasaDTO.class),
        @ApiResponse(code = 400, message = "Bad request", response = MessageDTO.class),
        @ApiResponse(code = 404, message = "Not found", response = MessageDTO.class)
    })
    public CasaDTO show(
            @ApiParam(required = true, name = "id", value = "ID della Casa che si vuole aggiornare", defaultValue = "0")
            @PathVariable Long id) {
        return service.trova(id);
    }

    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @ApiOperation(value = "Cancella casa", notes = "Cancella una Casa esistente")
    @ApiResponses({
        @ApiResponse(code = 204, message = "Success"),
        @ApiResponse(code = 404, message = "Not found", response = MessageDTO.class)
    })
    public void delete(
            @ApiParam(required = true, name = "id", value = "ID della Casa da cancellare")
            @PathVariable Long id) {
        service.cancella(id);
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public MessageDTO handleValidationException(MethodArgumentNotValidException ex) {
        Locale locale = LocaleContextHolder.getLocale();
        String code = ex.getBindingResult().getFieldError().getDefaultMessage();
        return new MessageDTO(messageSource.getMessage(code, null, locale));
    }

    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(CasaEntityNotFoundException.class)
    public MessageDTO handleNotFoundException(CasaEntityNotFoundException ex) {
        Locale locale = LocaleContextHolder.getLocale();
        return new MessageDTO(messageSource.getMessage("exception.EntityNotFound.description", parameters, locale));
    }
}
