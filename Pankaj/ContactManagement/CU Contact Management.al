codeunit 50149 "Contact Management"
{
    //TableNo = Customer;
    trigger OnRun();
    begin
        ContactAdded();
    end;

    procedure ContactAdded()
    begin
        /*
        //-->'Customer Contact Added' and 'Customer Contact Added by Person' 
         M1 := 0;
         M2 := 0;
         M3 := 0;
         M4 := 0;
         M5 := 0;
         M6 := 0;
         M7 := 0;
         M8 := 0;
         M9 := 0;
         M10 := 0;
         M11 := 0;
         M12 := 0;
         CLEAR(TempContactBuffer);
         TempContactBuffer.DELETEALL;
         ContactAddedData(MonthNo);
         NumVar := 0; //ReInitializing
         TempContactBuffer.RESET;
         TempContactBuffer.SETCURRENTKEY("Division Code", Integer_1);
         IF TempContactBuffer.FINDSET THEN BEGIN
             FirstVar := TRUE;
             REPEAT
                 IF (NOT FirstVar) AND (DivisionVar <> TempContactBuffer."Division Code") THEN BEGIN
                     NumVar += 2;
                     TempContactBuffer1.INIT;
                     TempContactBuffer1.Option := 'CONTACTMANAGEMENT';
                     TempContactBuffer1."Option Choice" := FORMAT(NumVar);
                     TempContactBuffer1.DefaultInteger := NumVar;
                     TempContactBuffer1.DefaultText250 := 'Total for Division ' + DivisionVar;
                     TempContactBuffer1."User ID" := 'Total for Division ' + DivisionVar;
                     TempContactBuffer1.DefaultInteger_1 := T1;
                     TempContactBuffer1.DefaultInteger_2 := T2;
                     TempContactBuffer1.DefaultInteger_3 := T3;
                     TempContactBuffer1.DefaultInteger_4 := T4;
                     TempContactBuffer1.DefaultInteger_5 := T5;
                     TempContactBuffer1.DefaultInteger_6 := T6;
                     TempContactBuffer1.DefaultInteger_7 := T7;
                     TempContactBuffer1.DefaultInteger_8 := T8;
                     TempContactBuffer1.DefaultInteger_9 := T9;
                     TempContactBuffer1.DefaultInteger_10 := T10;
                     TempContactBuffer1.DefaultInteger_11 := T11;
                     TempContactBuffer1.DefaultInteger_12 := T12;
                     TempContactBuffer1."Default Boolean" := TRUE;
                     TempContactBuffer1."Division Code" := DivisionVar; //Division Code
                     TempContactBuffer1.INSERT;
                     T1 := 0;
                     T2 := 0;
                     T3 := 0;
                     T4 := 0;
                     T5 := 0;
                     T6 := 0;
                     T7 := 0;
                     T8 := 0;
                     T9 := 0;
                     T10 := 0;
                     T11 := 0;
                     T12 := 0;
                 END;
                 NumVar += 2;
                 FirstVar := FALSE;

                 DivisionVar := TempContactBuffer."Division Code";
                 T1 += TempContactBuffer.DefaultInteger_1;
                 T2 += TempContactBuffer.DefaultInteger_2;
                 T3 += TempContactBuffer.DefaultInteger_3;
                 T4 += TempContactBuffer.DefaultInteger_4;
                 T5 += TempContactBuffer.DefaultInteger_5;
                 T6 += TempContactBuffer.DefaultInteger_6;
                 T7 += TempContactBuffer.DefaultInteger_7;
                 T8 += TempContactBuffer.DefaultInteger_8;
                 T9 += TempContactBuffer.DefaultInteger_9;
                 T10 += TempContactBuffer.DefaultInteger_10;
                 T11 += TempContactBuffer.DefaultInteger_11;
                 T12 += TempContactBuffer.DefaultInteger_12;
             UNTIL TempContactBuffer.NEXT = 0;
             NumVar += 2;
             TempContactBuffer1.INIT;
             TempContactBuffer1.Option := 'CONTACTMANAGEMENT';
             TempContactBuffer1."Option Choice" := FORMAT(NumVar);
             TempContactBuffer1.DefaultInteger := NumVar;
             TempContactBuffer1.DefaultText250 := 'Total for Division ' + DivisionVar;
             TempContactBuffer1."User ID" := 'Total for Division ' + DivisionVar;
             TempContactBuffer1.DefaultInteger_1 := T1;
             TempContactBuffer1.DefaultInteger_2 := T2;
             TempContactBuffer1.DefaultInteger_3 := T3;
             TempContactBuffer1.DefaultInteger_4 := T4;
             TempContactBuffer1.DefaultInteger_5 := T5;
             TempContactBuffer1.DefaultInteger_6 := T6;
             TempContactBuffer1.DefaultInteger_7 := T7;
             TempContactBuffer1.DefaultInteger_8 := T8;
             TempContactBuffer1.DefaultInteger_9 := T9;
             TempContactBuffer1.DefaultInteger_10 := T10;
             TempContactBuffer1.DefaultInteger_11 := T11;
             TempContactBuffer1.DefaultInteger_12 := T12;
             TempContactBuffer1."Default Boolean" := TRUE;
             TempContactBuffer1."Division Code" := DivisionVar; //Division Code
             TempContactBuffer1.INSERT;
         END;
         TempContactBuffer.DELETEALL;
         TempContactBuffer1.RESET;
         IF TempContactBuffer1.FINDFIRST THEN
             REPEAT
                 TempContactBuffer.INIT;
                 TempContactBuffer.TRANSFERFIELDS(TempContactBuffer1);
                 TempContactBuffer.INSERT;
             UNTIL TempContactBuffer1.NEXT = 0;

         //Write code to transfer from temporary to permanent
         NumVar := 100;
         TempContactBuffer.RESET;
         TempContactBuffer.SETCURRENTKEY(DefaultInteger);
         IF TempContactBuffer.FINDSET THEN
             REPEAT
                 ContactBufferPermanent.RESET;
                 ContactBufferPermanent.SETRANGE(Option, 'DUMPCONTACTLOG');
                 ContactBufferPermanent.SETRANGE("Division Code", TempContactBuffer."Division Code");
                 ContactBufferPermanent.SETRANGE("DefaultText 30_1", '20' + YearVar);  //it will add total contact line also
                 IF ContactBufferPermanent.FINDFIRST THEN BEGIN
                     IF MonthNo = 1 THEN
                         ContactBufferPermanent.DefaultInteger_1 := TempContactBuffer.DefaultInteger_1
                     ELSE
                         IF MonthNo = 2 THEN
                             ContactBufferPermanent.DefaultInteger_2 := TempContactBuffer.DefaultInteger_2
                         ELSE
                             IF MonthNo = 3 THEN
                                 ContactBufferPermanent.DefaultInteger_3 := TempContactBuffer.DefaultInteger_3
                             ELSE
                                 IF MonthNo = 4 THEN
                                     ContactBufferPermanent.DefaultInteger_4 := TempContactBuffer.DefaultInteger_4
                                 ELSE
                                     IF MonthNo = 5 THEN
                                         ContactBufferPermanent.DefaultInteger_5 := TempContactBuffer.DefaultInteger_5
                                     ELSE
                                         IF MonthNo = 6 THEN
                                             ContactBufferPermanent.DefaultInteger_6 := TempContactBuffer.DefaultInteger_6
                                         ELSE
                                             IF MonthNo = 7 THEN
                                                 ContactBufferPermanent.DefaultInteger_7 := TempContactBuffer.DefaultInteger_7
                                             ELSE
                                                 IF MonthNo = 8 THEN
                                                     ContactBufferPermanent.DefaultInteger_8 := TempContactBuffer.DefaultInteger_8
                                                 ELSE
                                                     IF MonthNo = 9 THEN
                                                         ContactBufferPermanent.DefaultInteger_9 := TempContactBuffer.DefaultInteger_9
                                                     ELSE
                                                         IF MonthNo = 10 THEN
                                                             ContactBufferPermanent.DefaultInteger_10 := TempContactBuffer.DefaultInteger_10
                                                         ELSE
                                                             IF MonthNo = 11 THEN
                                                                 ContactBufferPermanent.DefaultInteger_11 := TempContactBuffer.DefaultInteger_11
                                                             ELSE
                                                                 IF MonthNo = 12 THEN
                                                                     ContactBufferPermanent.DefaultInteger_12 := TempContactBuffer.DefaultInteger_12;
                     ContactBufferPermanent.MODIFY;
                     NumVar := ContactBufferPermanent.DefaultInteger;
                 END ELSE BEGIN
                     ContactBufferPermanent.INIT;
                     ContactBufferPermanent.Option := 'DUMPCONTACTLOG';
                     ContactBufferPermanent."Option Choice" := FORMAT(NumVar + 10);
                     ContactBufferPermanent.DefaultInteger := NumVar + 10;
                     ContactBufferPermanent."DefaultText 30_1" := '20' + YearVar;
                     ContactBufferPermanent.DefaultText250 := 'Total for Division ' + TempContactBuffer."Division Code";
                     ContactBufferPermanent."User ID" := 'Total for Division ' + TempContactBuffer."Division Code";
                     ContactBufferPermanent."Division Code" := TempContactBuffer."Division Code";
                     IF MonthNo = 1 THEN
                         ContactBufferPermanent.DefaultInteger_1 := TempContactBuffer.DefaultInteger_1
                     ELSE
                         IF MonthNo = 2 THEN
                             ContactBufferPermanent.DefaultInteger_2 := TempContactBuffer.DefaultInteger_2
                         ELSE
                             IF MonthNo = 3 THEN
                                 ContactBufferPermanent.DefaultInteger_3 := TempContactBuffer.DefaultInteger_3
                             ELSE
                                 IF MonthNo = 4 THEN
                                     ContactBufferPermanent.DefaultInteger_4 := TempContactBuffer.DefaultInteger_4
                                 ELSE
                                     IF MonthNo = 5 THEN
                                         ContactBufferPermanent.DefaultInteger_5 := TempContactBuffer.DefaultInteger_5
                                     ELSE
                                         IF MonthNo = 6 THEN
                                             ContactBufferPermanent.DefaultInteger_6 := TempContactBuffer.DefaultInteger_6
                                         ELSE
                                             IF MonthNo = 7 THEN
                                                 ContactBufferPermanent.DefaultInteger_7 := TempContactBuffer.DefaultInteger_7
                                             ELSE
                                                 IF MonthNo = 8 THEN
                                                     ContactBufferPermanent.DefaultInteger_8 := TempContactBuffer.DefaultInteger_8
                                                 ELSE
                                                     IF MonthNo = 9 THEN
                                                         ContactBufferPermanent.DefaultInteger_9 := TempContactBuffer.DefaultInteger_9
                                                     ELSE
                                                         IF MonthNo = 10 THEN
                                                             ContactBufferPermanent.DefaultInteger_10 := TempContactBuffer.DefaultInteger_10
                                                         ELSE
                                                             IF MonthNo = 11 THEN
                                                                 ContactBufferPermanent.DefaultInteger_11 := TempContactBuffer.DefaultInteger_11
                                                             ELSE
                                                                 IF MonthNo = 12 THEN
                                                                     ContactBufferPermanent.DefaultInteger_12 := TempContactBuffer.DefaultInteger_12;
                     ContactBufferPermanent.INSERT;
                 END;
             UNTIL TempContactBuffer.NEXT = 0;
         ContactBufferPermanent.RESET;
         ContactBufferPermanent.SETRANGE(Option, 'DUMPCONTACTLOG');
         //ContactBufferPermanent.SETRANGE("Division Code",TempContactBuffer."Division Code");
         ContactBufferPermanent.SETRANGE(DefaultText250, 'Total Contact');  //it will add total contact line also
         ContactBufferPermanent.SETRANGE("DefaultText 30_1", '20' + YearVar);
         IF ContactBufferPermanent.FINDFIRST THEN BEGIN
             IF MonthNo = 1 THEN
                 ContactBufferPermanent.DefaultInteger_1 := M1
             ELSE
                 IF MonthNo = 2 THEN
                     ContactBufferPermanent.DefaultInteger_2 := M2
                 ELSE
                     IF MonthNo = 3 THEN
                         ContactBufferPermanent.DefaultInteger_3 := M3
                     ELSE
                         IF MonthNo = 4 THEN
                             ContactBufferPermanent.DefaultInteger_4 := M4
                         ELSE
                             IF MonthNo = 5 THEN
                                 ContactBufferPermanent.DefaultInteger_5 := M5
                             ELSE
                                 IF MonthNo = 6 THEN
                                     ContactBufferPermanent.DefaultInteger_6 := M6
                                 ELSE
                                     IF MonthNo = 7 THEN
                                         ContactBufferPermanent.DefaultInteger_7 := M7
                                     ELSE
                                         IF MonthNo = 8 THEN
                                             ContactBufferPermanent.DefaultInteger_8 := M8
                                         ELSE
                                             IF MonthNo = 9 THEN
                                                 ContactBufferPermanent.DefaultInteger_9 := M9
                                             ELSE
                                                 IF MonthNo = 10 THEN
                                                     ContactBufferPermanent.DefaultInteger_10 := M10
                                                 ELSE
                                                     IF MonthNo = 11 THEN
                                                         ContactBufferPermanent.DefaultInteger_11 := M11
                                                     ELSE
                                                         IF MonthNo = 12 THEN
                                                             ContactBufferPermanent.DefaultInteger_12 := M12;
             ContactBufferPermanent.MODIFY;
         END ELSE BEGIN
             ContactBufferPermanent.INIT;
             ContactBufferPermanent.Option := 'DUMPCONTACTLOG';
             ContactBufferPermanent."Option Choice" := FORMAT(NumVar + 100);
             ContactBufferPermanent.DefaultText250 := 'Total Contact';
             ContactBufferPermanent."DefaultText 30_1" := '20' + YearVar;
             IF MonthNo = 1 THEN
                 ContactBufferPermanent.DefaultInteger_1 := M1
             ELSE
                 IF MonthNo = 2 THEN
                     ContactBufferPermanent.DefaultInteger_2 := M2
                 ELSE
                     IF MonthNo = 3 THEN
                         ContactBufferPermanent.DefaultInteger_3 := M3
                     ELSE
                         IF MonthNo = 4 THEN
                             ContactBufferPermanent.DefaultInteger_4 := M4
                         ELSE
                             IF MonthNo = 5 THEN
                                 ContactBufferPermanent.DefaultInteger_5 := M5
                             ELSE
                                 IF MonthNo = 6 THEN
                                     ContactBufferPermanent.DefaultInteger_6 := M6
                                 ELSE
                                     IF MonthNo = 7 THEN
                                         ContactBufferPermanent.DefaultInteger_7 := M7
                                     ELSE
                                         IF MonthNo = 8 THEN
                                             ContactBufferPermanent.DefaultInteger_8 := M8
                                         ELSE
                                             IF MonthNo = 9 THEN
                                                 ContactBufferPermanent.DefaultInteger_9 := M9
                                             ELSE
                                                 IF MonthNo = 10 THEN
                                                     ContactBufferPermanent.DefaultInteger_10 := M10
                                                 ELSE
                                                     IF MonthNo = 11 THEN
                                                         ContactBufferPermanent.DefaultInteger_11 := M11
                                                     ELSE
                                                         IF MonthNo = 12 THEN
                                                             ContactBufferPermanent.DefaultInteger_12 := M12;
             ContactBufferPermanent.DefaultInteger := NumVar + 100;
             ContactBufferPermanent.INSERT;
         END;
         */
    end;

    var
        automaticvar: Boolean;
        DateVar: Date;
        M1: Decimal;
        M2: Decimal;
        M3: Decimal;
        NumVar: Integer;
        RowNo: Integer;
        ColumnNo: Integer;
        MonthNo: Integer;
        M4: Integer;
        M5: Integer;
        M6: Integer;
        M7: Integer;
        M8: Integer;
        M9: Integer;
        M10: Integer;
        M11: Integer;
        M12: Integer;
        QuarterVar: Option;
        TempContactBuffer: Record "Contact Buffer" temporary;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Contact: Record Contact;
        YearVarFilter: Text[4];
        YearVar: Text[4];
        QMonth1: Text[10];
        QMonth2: Text[10];
        QMonth3: Text[10];
        QMonth4: Text[10];
        QMonth5: Text[10];
        QMonth6: Text[10];
        QMonth7: Text[10];
        QMonth8: Text[10];
        QMonth9: Text[10];
        QMonth10: Text[10];
        QMonth11: Text[10];
        QMonth12: Text[10];
        QMonth1Fil: Text[30];
        QMonth2Fil: Text[30];
        QMonth3Fil: Text[30];
        QMonth4Fil: Text[30];
        QMonth5Fil: Text[30];
        QMonth6Fil: Text[30];
        QMonth7Fil: Text[30];
        QMonth8Fil: Text[30];
        QMonth9Fil: Text[30];
        QMonth10Fil: Text[30];
        QMonth11Fil: Text[30];
        QMonth12Fil: Text[30];
        MonthTxt1: Text[20];
        MonthTxt2: Text[20];
        MonthTxt3: Text[20];
        MonthTxt4: Text[20];
        MonthTxt5: Text[20];
        MonthTxt6: Text[20];
        MonthTxt7: Text[20];
        MonthTxt8: Text[20];
        MonthTxt9: Text[20];
        MonthTxt10: Text[20];
        MonthTxt11: Text[20];
        MonthTxt12: Text[20];


}