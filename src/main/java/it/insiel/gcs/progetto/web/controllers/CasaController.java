package it.insiel.gcs.progetto.web.controllers;

import it.insiel.gcs.progetto.business.dtos.CasaDTO;
import it.insiel.gcs.progetto.business.services.CasaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class CasaController {

    @Autowired
    private CasaService service;

    @RequestMapping(value = "/case", method = RequestMethod.GET, produces = ("text/html"))
    public ModelAndView index(){
        ModelAndView mav = new ModelAndView("casa/index");
								mav.addObject("case",service.trovaTutti());
								return mav;
    }

		@RequestMapping(value = "/case/{id}", method = RequestMethod.GET, produces = ("text/html"))
    public ModelAndView dettaglio(@PathVariable Long id){
        ModelAndView mav = new ModelAndView("casa/dettaglio");
				mav.addObject("casa",service.trova(id));
				return mav;
    }

		@RequestMapping(value = "/case/new", method = RequestMethod.GET, produces = ("text/html"))
    public ModelAndView nuovo(){
        ModelAndView mav = new ModelAndView("casa/nuovo");
				mav.addObject("casa",new CasaDTO());
				return mav;
    }

		@RequestMapping(value = "/case/{id}/edit", method = RequestMethod.GET, produces = ("text/html"))
    public ModelAndView modifica(@PathVariable Long id){
        ModelAndView mav = new ModelAndView("casa/modifica");
				mav.addObject("casa",service.trova(id));
				return mav;
    }

    @RequestMapping(value = "/case",method = RequestMethod.POST)
    public String salva(@ModelAttribute CasaDTO model){
				CasaDTO newModel = service.salva(model);
        return "redirect:/case/"+newModel.getId();
    }

		@RequestMapping(value = "/case/{id}",method = {RequestMethod.POST, RequestMethod.PUT})
    public String salva(@PathVariable Long id, @ModelAttribute CasaDTO model){
				CasaDTO newModel = service.salva(model);
        return "redirect:/case/"+newModel.getId();
    }

    @RequestMapping(value = "/casa/{id}",method = RequestMethod.DELETE)
    public String deleteRest(@PathVariable Long id){
				Long idDeleted = service.cancella(id);
				return "redirect:/case";
    }

		@RequestMapping(value = "/casa/{id}/delete",method = RequestMethod.GET)
    public String delete(@PathVariable Long id){
				Long idDeleted = service.cancella(id);
				return "redirect:/case";
    }

		@RequestMapping(value = "/case", method = RequestMethod.GET, produces = ("application/json"))
		@ResponseBody
    public List<CasaDTO> indexJson(){
        return service.trovaTutti();
    }

		@RequestMapping(value = "/case/{id}", method = RequestMethod.GET, produces = ("application/json"))
		@ResponseBody
    public CasaDTO dettaglioJson(@PathVariable Long id){
				return service.trova(id);
    }

}
