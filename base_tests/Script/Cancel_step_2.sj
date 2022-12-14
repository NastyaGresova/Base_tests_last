function Test5()     // отменить назначение
{    
      var w0=Sys.Process("Automedi");   

      var canc_note = Runner.CallMethod("Unit_var.return_cancelled_note");
      
      //создаем новую запись 
      w0.VCLObject("AMMain").VCLObject("bNewEditCons").Click();
      w0.VCLObject("fNewCons").VCLObject("PageControl2").VCLObject("MainTabSheet").VCLObject("BasePanel").VCLObject("TypeRecPanel").Window("TPanel", "", 1).VCLObject("lbModels").Keys(Runner.CallMethod("Unit_var.return_name_motconsu")); 
      w0.VCLObject("fNewCons").VCLObject("Panel1").VCLObject("Panel2").VCLObject("BitBtn1").Click();
      
      /*if (w0.Window("TMessageForm", "Подтверждение", 1) !== false)
      {
           w0.Window("TMessageForm", "Подтверждение", 1).VCLObject("No").Click();
      } */
      
      if (w0.WaitWindow("TMessageForm", "Подтверждение", -1, 1500).Exists)   
      {
           w0.Window("TMessageForm", "Подтверждение", 1).VCLObject("No").Click();
      } 
      
      //вот тут нужно добавить условие : 
      //find_EF  не ищет амбулаторные назначения по экранной форме. Он именно нажимает на нужную кнопку, т.е. выбирает нужную ЭФ, где есть объект "амбулаторные назначения" 
      Runner.CallMethod("Unit_var.find_EF");
      
      //вышла на форму с амбулаторными назначениями          
      delay(7000)

      //w1 - объект "амбулаторные назначения"
      var w1 = Runner.CallMethod("Unit_var.return_w1");
  
      var w_AmbForm = w1.Window("TTabSheet", "Амбулаторные назначения", 1).VCLObject("PatDrugDocAmbForm");
      
      //грид: 
      w_grid = w_AmbForm.VCLObject("pGrid").VCLObject("GridPanel").VCLObject("Grid");
      w_grid.VScroll.Pos=1;
      delay(2000);
      
      w_AmbForm.VCLObject("PanelTop").VCLObject("TabControl1").VCLObject("PanelNaznach").VCLObject("SimplePanel").VCLObject("edMed").Click();
      w_grid.VScroll.Pos = (w_grid.VScroll.Max - 1) ;
      delay(1500);
  
      //кнопка для отмены ранее назначенного 
      w_AmbForm.VCLObject("pTop").VCLObject("pTool").VCLObject("ToolBar").VCLObject("TToolButton_7").Click(); 

      // подтверждение перед отменой:
      Sys.Process("Automedi").Window("TMessageForm", "Подтверждение", 1).VCLObject("Yes").Click();

      // окошко для комментария:
      w_comment= Sys.Process("Automedi").VCLObject("fInputQ");
      w_comment.VCLObject("Edit1").Keys(canc_note);  //тут нужно переменную приделать
      w_comment.VCLObject("bOk").Click();
      
      delay(2000);  

      w_grid.VScroll.Pos = w_grid.VScroll.Max;
      delay(1000);
      w_grid.VScroll.Pos = (w_grid.VScroll.Max - 1);
      delay(1000); 
      w_grid.VScroll.Pos = w_grid.VScroll.Max;
      delay(1000); 
      //обновляю грид после отмены назначения 
      w_AmbForm.VCLObject("tbRefresh").Click();  
      delay(3000);
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
 
      w_checkpoint = Runner.CallMethod("Unit_var.return_w_checkpoint", w3);
  
      aqObject.CheckProperty(w_checkpoint.VCLObject("pnHeader").VCLObject("pnPrMain").VCLObject("edMed"), "wText", 0, DRUG_DESCR);
      //aqObject.CheckProperty(w3.VCLObject("pRecord").VCLObject("pcPrescr").VCLObject("tsIntakeScheme").VCLObject("pnTemplate").VCLObject("fmPRPlanBuilder_1").VCLObject("pnPrTemplate").VCLObject("memTotalDescription"), "wText", 0, DESCRIPTION);    // вот тут какая-то ошибка????
  
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
      if (Number(CANCELLED)!=1)
      {
          Log.Error("Field_CANCELLED") ;
      }

      if (REANIM!=0)
      {
          Log.Error("Field_REANIM") ;
      }
  
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
  
      w3.Close();
     
      delay(2500);
   
      /*это не работает, я не понимаю, почему
      if (String(CANCELED_NOTE) !== canc_note)
      {
      //var y = "тест123TEST!@#$%)(_"
      //Log.Message(typeof(y))
          Log.Message(CANCELED_NOTE)
          Log.Message(String(CANCELED_NOTE))
          Log.Message(typeof(String(CANCELED_NOTE)))
          Log.Error("Field_CANCELLED_NOTE") ;
      }        */  
  
      //удаление назначения  
      w_grid.VScroll.Pos=2;
      delay(1000);
      w_grid.VScroll.Pos=3;
      delay(1000); 
      w_grid.VScroll.Pos=2;
      delay(1500);    
}
  