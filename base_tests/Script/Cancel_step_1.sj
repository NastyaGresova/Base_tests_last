function Test4()     // отменить назначение  (с комментарием) , тут только создаем назначение
{
      var w0=Sys.Process("Automedi");  
 
      //сначала создам запись
  /*  w0.VCLObject("AMMain").VCLObject("bNewEditCons").Click();
      w0.VCLObject("fNewCons").VCLObject("PageControl2").VCLObject("MainTabSheet").VCLObject("BasePanel").VCLObject("TypeRecPanel").Window("TPanel", "", 1).VCLObject("lbModels").Keys(Runner.CallMethod("Unit_var.return_name_motconsu")); 
      w0.VCLObject("fNewCons").VCLObject("Panel1").VCLObject("Panel2").VCLObject("BitBtn1").Click();
      if (w0.Window("TMessageForm", "Подтверждение", 1) !== false)
      {
           w0.Window("TMessageForm", "Подтверждение", 1).VCLObject("No").Click();
      }  
      w0.VCLObject("AMMain").VCLObject("TSpeedButton_5").Click(); 

      //вышла на форму с амбулаторными назначениями          
      delay(7000)     */

      //w1 - объект "амбулаторные назначения"
      var w1 = Runner.CallMethod("Unit_var.return_w1");
  
      var w_AmbForm = w1.Window("TTabSheet", "Амбулаторные назначения", 1).VCLObject("PatDrugDocAmbForm");
      
      // грид: 
      w_grid = w_AmbForm.VCLObject("pGrid").VCLObject("GridPanel").VCLObject("Grid");
      w_grid.VScroll.Pos=1;
      delay(1000);
        
      //нужно сперва создать назначение:
      w_AmbForm.VCLObject("PanelTop").VCLObject("TabControl1").VCLObject("PanelNaznach").VCLObject("SimplePanel").VCLObject("edMed").Click();

      // w2 - глоссарий справа
      var w2 = Runner.CallMethod("Unit_var.return_w2"); 
      w2.ClickTab("Список"); 
      delay(1500); 
        
      w2.VCLObject("tsDrugList").VCLObject("GridDrugsForm").VCLObject("pGrid").VCLObject("pSearch").Window("TEdit", "", 1).Keys(Runner.CallMethod("Unit_var.pr_drugs_id"));
      delay(1000);
      w2.VCLObject("tsDrugList").VCLObject("GridDrugsForm").VCLObject("tbAddDrug").Click();
         
      Runner.CallMethod("Unit_var.close_confirmation_window", w0);
 
      Runner.CallMethod("Unit_var.intake", w_AmbForm.VCLObject("PanelTop").VCLObject("TabControl1"), Runner.CallMethod("Unit_var.intake_method_i"));
      delay(1000); 
      w_AmbForm.VCLObject("PanelTop").VCLObject("TabControl1").VCLObject("PanelNaznach").VCLObject("btnAddDrugPrescr").Click();
      delay(1000);
      w_grid.VScroll.Pos=2;
      delay(1000);
      w_grid.VScroll.Pos=3;
      delay(1000); 
      w_grid.VScroll.Pos=2;
      delay(1000); 

}