function Test7()     // создать простое назначение, по кнопке в тулбаре
{     
      var w0 = Sys.Process("Automedi");
      //w1 - объект "амбулаторные назначения"
      var w1 = Runner.CallMethod("Unit_var.return_w1");
  
      var w_AmbForm = w1.Window("TTabSheet", "Амбулаторные назначения", 1).VCLObject("PatDrugDocAmbForm"); 
      
      //грид: 
      w_grid = w_AmbForm.VCLObject("pGrid").VCLObject("GridPanel").VCLObject("Grid");
  
      //нужно сперва создать назначение:
      w_AmbForm.VCLObject("PanelTop").VCLObject("TabControl1").VCLObject("PanelNaznach").VCLObject("SimplePanel").VCLObject("edMed").Click();
  
      w_grid.VScroll.Pos=1;
      delay(1200);
    
      w_AmbForm.VCLObject("pTop").VCLObject("pTool").VCLObject("ToolBar").VCLObject("TToolButton").Click(39, 21);
      w_AmbForm.VCLObject("pTop").VCLObject("pTool").VCLObject("ToolBar").PopupMenu.Click("Назначить препарат из списка");   
  
      // w_find_drug - окно для поиска медикаментов
      w_find_drug = Sys.Process("Automedi").VCLObject("fDrugsView")
  
      w_find_drug.VCLObject("pGrid").VCLObject("pSearch").VCLObject("pSearchAuto").Window("TEdit", "", 1).Keys(Runner.CallMethod("Unit_var.pr_drugs_id"));
      delay (1000);
      w_find_drug.VCLObject("BtnOk").Click();
      delay (1200);
        
      //это обход ошибки, но ее быть не должно (появляются лишние окна):
      if (w0.WaitVCLObject("DBDocForm", 1500).Exists)   
      {
            w0.VCLObject("DBDocForm").Close(); 
      }
      delay (1000);  
  
      if (w0.WaitVCLObject("PatDirLookDoc",  1500).Exists)   
      {            
            w0.VCLObject("PatDirLookDoc").VCLObject("pGrid").VCLObject("pcGrids").VCLObject("tsExams").VCLObject("pSearch").Window("TEdit", "", 3).Keys("МЕДИКАМЕНТЫ_1");
            w0.VCLObject("PatDirLookDoc").VCLObject("BtnOk").Click();
      }
      delay (1200);
    
      // окно-редактор медикамента
      var w3 = Runner.CallMethod("Unit_var.return_w3");
  
      w_checkpoint = Runner.CallMethod("Unit_var.return_w_checkpoint", w3);
  
      // w_gloss - глоссарий в окне - редакторе назначения
 
      if (w3.VCLObject("pRecord").WaitVCLObject("pGlossaire",  1500).Exists)
      {
            w_gloss = w3.VCLObject("pRecord").VCLObject("pGlossaire").VCLObject("pMain").VCLObject("PageControl1").VCLObject("GlossarySheet").VCLObject("tcGlossKind").Window("TGlossViewer", "", 1)
      }
      else
      {
            w3.ClickR(34, 15);
            w3.SystemMenu.Click("Встроенный глоссарий");
            w_gloss = w3.VCLObject("pRecord").VCLObject("pGlossaire").VCLObject("pMain").VCLObject("PageControl1").VCLObject("GlossarySheet").VCLObject("tcGlossKind").Window("TGlossViewer", "", 1)
      }
  
      w_checkpoint.VCLObject("pnHeader").VCLObject("pnPrMain").VCLObject("dblPrIntakeMethods").VCLObject("Code").Window("Edit", "", 1).Click();

      var i = Runner.CallMethod("Unit_var.intake_method_i");
      var j=i*15.6-5;
      w_gloss.DblClick(38, j);
  
      w3.VCLObject("pRecord").VCLObject("pcPrescr").ClickTab("Схема приема");  
  
      delay(3000);

      var str = (w_checkpoint.VCLObject("pnPrTemplate").VCLObject("pnTemplateToolBar").VCLObject("pnCbTemplate").VCLObject("cbTemplate").wItemList);
      scheme_name = Runner.CallMethod("Unit_var.return_scheme_name_window_DirServEditor");
      if (str.indexOf(scheme_name)!=-1)
      {
            w_checkpoint.VCLObject("pnPrTemplate").VCLObject("pnTemplateToolBar").VCLObject("pnCbTemplate").VCLObject("cbTemplate").ClickItem(Runner.CallMethod("Unit_var.return_scheme_name_window_DirServEditor")); 
      }
      else
      {
            w_checkpoint.VCLObject("tbbNewTemplate").Click();
            Sys.Process("Automedi").VCLObject("fmPrTemplatesLookDoc").VCLObject("pGrid").VCLObject("pnTemplateTabs").VCLObject("pcTemplateFilter").ClickTab("Все")
            Sys.Process("Automedi").VCLObject("fmPrTemplatesLookDoc").VCLObject("pGrid").VCLObject("pSearch").Window("TEdit", "", 1).Keys(Runner.CallMethod("Unit_var.return_scheme_name_window_DirServEditor"));
            delay (1500);
            Sys.Process("Automedi").VCLObject("fmPrTemplatesLookDoc").VCLObject("BtnOk").Click();
      }
    
      if (w0.WaitWindow("TMessageForm", "Подтверждение", -1, 1500).Exists)
      {
            Sys.Process("Automedi").Window("TMessageForm", "Подтверждение", 1).VCLObject("No").Click(); 
      }
  
      delay(1500);
      w3.VCLObject("tbClose").Click();
  
      delay(4500);
  
      //открываю на просмотр                
      w_AmbForm.VCLObject("pTop").VCLObject("pTool").VCLObject("ToolBar").VCLObject("TToolButton_11").Click();

      // w3 - окно-редактор медикамента
      var w3 = Runner.CallMethod("Unit_var.return_w3");
  
      //делаю запросы к БД, чтобы дальше проверить, что в БД все правильно заполнено
      var query_patdirec_drugs = "select top 1 * from PATDIREC_DRUGS order by patdirec_id desc";
      RecSet_patdirec_drug = Runner.CallMethod("Unit_var.db_connection", query_patdirec_drugs ); 
  
      DRUG_DESCR = RecSet_patdirec_drug.Fields("DRUG_DESCR");
      IS_MIXT =  RecSet_patdirec_drug.Fields("IS_MIXT");
      PR_TYPE =  RecSet_patdirec_drug.Fields("PR_TYPE");
      DM_MEASURE_ID = RecSet_patdirec_drug.Fields("DM_MEASURE_ID");
      DOSE_COUNT = RecSet_patdirec_drug.Fields("DOSE_COUNT"); 
      PR_INTAKE_METHODS_ID = RecSet_patdirec_drug.Fields("PR_INTAKE_METHODS_ID");
    
      var query_patdirec = "select top 1 * from PATDIREC order by patdirec_id desc";
      RecSet_patdirec = Runner.CallMethod("Unit_var.db_connection", query_patdirec);
    
      DESCRIPTION = RecSet_patdirec.Fields("DESCRIPTION");
      COMMENTAIRE = RecSet_patdirec.Fields("COMMENTAIRE");                   
      CANCELLED  = RecSet_patdirec.Fields("CANCELLED"); 
      CANCELED_NOTE = RecSet_patdirec.Fields("CANCELED_NOTE"); 
      BEGIN_DATE_TIME = RecSet_patdirec.Fields("BEGIN_DATE_TIME"); 
      END_DATE_TIME  = RecSet_patdirec.Fields("END_DATE_TIME"); 
      TEMPLATE_XML  = RecSet_patdirec.Fields("TEMPLATE_XML"); 
      PATDIREC_TYPE = RecSet_patdirec.Fields("PATDIREC_TYPE"); 
      PATDIREC_KIND = RecSet_patdirec.Fields("PATDIREC_KIND");    
      REANIM = RecSet_patdirec.Fields("REANIM");
 
      aqObject.CheckProperty(w_checkpoint.VCLObject("pnHeader").VCLObject("pnPrMain").VCLObject("edMed"), "wText", 0, DRUG_DESCR);
      aqObject.CheckProperty(w_checkpoint.VCLObject("pnPrTemplate").VCLObject("memTotalDescription"), "wText", 0, DESCRIPTION);  
  
      if (w_checkpoint.VCLObject("pnHeader").VCLObject("pnPrMain").VCLObject("memComment").wText=="")
      {
          if (Number(COMMENTAIRE)!=0)
          {
              Log.Error("Field_COMMENTAIRE");
          }            
      }
      else   
      {  
         aqObject.CheckProperty(w_checkpoint.VCLObject("pnHeader").VCLObject("pnPrMain").VCLObject("memComment"), "wText", 0, COMMENTAIRE);
      }
      if (Number(CANCELLED)!=0)
      {
          Log.Error("Field_CANCELLED") ;
      }
  
      if (Number(CANCELED_NOTE)!=0)
      {
          Log.Error("Field_CANCELLED_NOTE") ;
      } 
  
      if (REANIM!=0)
      {
          Log.Error("Field_REANIM") ;
      }

      //это ошибка, надо исправить 
  
      if (PATDIREC_TYPE!=5)
      {
          Log.Error("Field_PATDIREC_TYPE") ;
      }         
  
      if (PATDIREC_KIND!=1)
      {
          Log.Error("Field_PATDIREC_KIND") ;
      }
    
      if (w_checkpoint.VCLObject("pnHeader").VCLObject("pnPrMain").VCLObject("cbxIsMixt").wState==0)
      {
          if (IS_MIXT!=0)
          {
            Log.Error("Field_IS_MIXT") ; 
          }
      }
      else
      {
          if (IS_MIXT!=1)
          {
            Log.Error("Field_IS_MIXT") ; 
          }  
      }
          
      delay(1500);
  
      //удаление назначения  
      w3.Close();
      w_grid.VScroll.Pos=2;
      delay(500);
      w_grid.VScroll.Pos=3;
      delay(500); 
      w_grid.VScroll.Pos=2;
      delay(500);
  
      w_AmbForm.VCLObject("pTop").VCLObject("pTool").VCLObject("ToolBar").VCLObject("TToolButton_13").Click();
      // подтверждение перед удалением:
      Sys.Process("Automedi").Window("TMessageForm", "Подтверждение", 1).VCLObject("Yes").Click();
      delay(2500);
      w_grid.VScroll.Pos=1;
 
}