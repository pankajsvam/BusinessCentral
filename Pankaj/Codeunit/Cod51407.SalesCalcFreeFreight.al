codeunit 51407 "Sales-Calc. Free Freight"
{
    // version TPZ000.00.00

    // 2015-05-29 TPZ573 VCHERNYA
    //   Codeunit has been created
    // 2015-07-10 TPZ844 VCHERNYA
    //   Free Freight Reason Code handling has been added
    // 2015-09-04 TPZ874 VCHERNYA
    //   No Free Freight on E-Ship Agent Service handling has been added
    // 2016-02-17 TOP8717 TAKHMETO
    //   IsFreeFreight function has been modified
    // 2016-05-02 TPZ1548 EBAGIM
    //   Validating Free Fregiht on Split Orders
    // 2016-07-09 TPZ1608 EBAGIM
    //   Free Freight Override
    // 2016-08-10 TPZ1632 EBAGIM
    //   Fix order amount to include only items
    // 2016-10-10 TPZ1711 EBAGIM
    //   Free Freight Override - Remove Premium Service Restriction
    // 2017-10-22 TPZ1999 EBAGIM
    //   Free Freight Override - change to Fredight Override to lock free freight flag

    TableNo = "Sales Header";

    trigger OnRun();
    begin
        //"Free Freight" := IsFreeFreight(Rec);
    end;
    /*
        var
            Item : Record Item;
            Cust : Record Customer;
            CustDivision : Record "Customer Division";
            FreeFreightMinOrderAmt : Record "Free Freight Min. Order Amt.";
            SalesLine : Record "Sales Line";
            ShippingAgent : Record "Shipping Agent";
            EShipAgentService : Record "E-Ship Agent Service";
            Oversize : Boolean;

        procedure IsFreeFreight(SalesHeader : Record "Sales Header") : Boolean;
        var
            AllLocFreeFreight : Boolean;
            CurrLocFreeFreight : Boolean;
            OneLocNotFreeFreight : Boolean;
            LocAmount : Decimal;
            MasterSalesOrder : Record "Sales Header";
            TEXTErrOverride : Label 'You Must Select a Free Freight Override Reason Code';
            OrderAmount : Decimal;
            SalesInvHeader : Record "Sales Invoice Header";
        begin


            //<TPZ1608>
            if (SalesHeader."Free Freight Override"=true) and (SalesHeader."Free Freight"=true) and (SalesHeader."Free Freight Override Reason"=SalesHeader."Free Freight Override Reason"::" ")  then
                ERROR(TEXTErrOverride);
            //</TPZ1608>

            //EB
            //<TPZ1711>
            // <TPZ874>
            // Return no free freight if E-Ship Agent Service is no set to No Free Freight
            if ShippingAgent.GET(SalesHeader."Shipping Agent Code") and
               EShipAgentService.GET(
                 SalesHeader."Shipping Agent Code",
                 SalesHeader."E-Ship Agent Service",
                 EShipAgentService.WorldWideService(ShippingAgent,SalesHeader."Ship-to Country/Region Code")) and
               EShipAgentService."No Free Freight"
            then
              exit(false);
            // </TPZ874>
            //<TPZ1711>
            //<TPZ1548>


            //<TPZ1608><TPZ1999>
            if SalesHeader."Free Freight Override"=true then
               exit(SalesHeader."Free Freight");
            //</TPZ1608></TPZ1999>



            // Return free freight if Free Freight Reason Code is specified
            // <TPZ844>
            if SalesHeader."Free Freight Reason Code" <> '' then
              exit(true);
            // </TPZ844>


            // Determine if there are any oversize items in the order
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.",SalesHeader."No.");
            SalesLine.SETRANGE(Type,SalesLine.Type::Item);
            if SalesLine.FINDSET then
              repeat
                if Item.GET(SalesLine."No.") and
                   Item.Oversize
                then
                  Oversize := true;
              until SalesLine.NEXT = 0;
            // Calculate order amount excluding tax
            SalesHeader.CALCFIELDS(Amount);



            // Return free freight if shipping agent is of pickup type
            // <TOP8717>
            //IF ShippingAgent.GET(SalesHeader."Shipping Agent Code") AND
            //   (ShippingAgent.Type = ShippingAgent.Type::Pickup)
            //THEN
            //  EXIT(TRUE);
            // </TOP8717>
            //<TPZ1548>
            if SalesHeader."Master Order No."<>'' then begin
               SalesInvHeader.SETRANGE("Order No.",SalesHeader."Master Order No.");
               if SalesInvHeader.FINDFIRST then
                  if SalesInvHeader."Free Freight" then
                     exit(true);

               if MasterSalesOrder.GET(SalesHeader."Document Type",SalesHeader."Master Order No.") then
                 if MasterSalesOrder."Free Freight" then
                    exit(true);

            end;
            //<TPZ1548>

            // Return free freight if customer is set to get Free Freight
            if Cust.GET(SalesHeader."Sell-to Customer No.") and
               Cust."Free Freight"
            then
              exit(true);

            // Return free freight if customer for specific division is set to get Free Freight
            if CustDivision.GET(SalesHeader."Sell-to Customer No.",SalesHeader."Shortcut Dimension 5 Code") and
               CustDivision."Free Freight"
            then
              exit(true);


            //<TPZ1608>
            if SalesHeader."Free Freight Override"=true then
               exit(true);
            //</TPZ1608>





            //<TPZ1632>
                OrderAmount :=0;
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.",SalesHeader."No.");
                SalesLine.SETRANGE(Type,SalesLine.Type::Item);

                if SalesLine.FINDSET then
                  repeat
                   OrderAmount :=OrderAmount + SalesLine.Amount; //<TPZ1632>
                  until SalesLine.NEXT = 0;
            //</TPZ1632>

            // Return free freight if there is minimum order amount for customer and division
            if CustDivision.GET(SalesHeader."Sell-to Customer No.",SalesHeader."Shortcut Dimension 5 Code") and
               (CustDivision."Free Freight Min. Order Amount" <> 0)
            then
              if OrderAmount >= CustDivision."Free Freight Min. Order Amount" then   //<TPZ1632>
                exit(true)
              else
                exit(false);



            // Return free freight if there is minimum order amount for specific shipping agent (LOCAL)
            FreeFreightMinOrderAmt.RESET;
            FreeFreightMinOrderAmt.SETRANGE("Division Code",'');
            FreeFreightMinOrderAmt.SETRANGE("Shipping Agent Code",SalesHeader."Shipping Agent Code");
            if FreeFreightMinOrderAmt.FINDFIRST and
               (OrderAmount >= FreeFreightMinOrderAmt."Min. Order Amount")  //<TPZ1632>
            then
              exit(true);

            // Return free freight if there is minimum order amount for specific division (I) and location (1|25|50)
            AllLocFreeFreight := false;
            OneLocNotFreeFreight := false;

            FreeFreightMinOrderAmt.RESET;
            FreeFreightMinOrderAmt.SETRANGE("Division Code",SalesHeader."Shortcut Dimension 5 Code");
            FreeFreightMinOrderAmt.SETRANGE("Shipping Agent Code",SalesHeader."Shipping Agent Code");
            FreeFreightMinOrderAmt.SETFILTER("Location Code",'<>%1','');
            if FreeFreightMinOrderAmt.FINDSET then begin
              repeat
                LocAmount := 0;
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.",SalesHeader."No.");
                SalesLine.SETRANGE(Type,SalesLine.Type::Item);
                SalesLine.SETRANGE("Location Code",FreeFreightMinOrderAmt."Location Code");
                if SalesLine.FINDSET then
                  repeat
                    LocAmount := LocAmount + SalesLine.Amount;
                  until SalesLine.NEXT = 0;
                CurrLocFreeFreight :=
                  (LocAmount = 0) or
                  (LocAmount >= FreeFreightMinOrderAmt."Min. Order Amount");
                if (LocAmount <> 0) and
                   (LocAmount < FreeFreightMinOrderAmt."Min. Order Amount")
                then
                  OneLocNotFreeFreight := true;
                AllLocFreeFreight := CurrLocFreeFreight and not OneLocNotFreeFreight;
              until FreeFreightMinOrderAmt.NEXT = 0;
              exit(AllLocFreeFreight);
            end;

            // Return free freight if there is minimum order amount for specific division (E or L)
            FreeFreightMinOrderAmt.RESET;
            FreeFreightMinOrderAmt.SETRANGE("Division Code",SalesHeader."Shortcut Dimension 5 Code");
            FreeFreightMinOrderAmt.SETRANGE("Location Code",SalesHeader."Location Code");
            FreeFreightMinOrderAmt.SETRANGE(Oversize,Oversize);
            if FreeFreightMinOrderAmt.FINDFIRST and
               (OrderAmount >= FreeFreightMinOrderAmt."Min. Order Amount") //<TPZ1632>
            then
              exit(true);

            // Return free freight in other cases (for all other divisions and locations)
            FreeFreightMinOrderAmt.RESET;
            FreeFreightMinOrderAmt.SETRANGE("Division Code",'');
            FreeFreightMinOrderAmt.SETRANGE("Location Code",'');
            FreeFreightMinOrderAmt.SETRANGE(Oversize,Oversize);
            if FreeFreightMinOrderAmt.FINDFIRST and
               (OrderAmount >= FreeFreightMinOrderAmt."Min. Order Amount")//<TPZ1632>
            then
              exit(true);

            // Return not free freight if no conditions for free freight found
            exit(false);
        end;

        procedure GetFreeFreightMinOrderAmount(SalesHeader : Record "Sales Header") : Decimal;
        begin
            // Determine if there are any oversize items in the order
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.",SalesHeader."No.");
            SalesLine.SETRANGE(Type,SalesLine.Type::Item);
            if SalesLine.FINDSET then
              repeat
                if Item.GET(SalesLine."No.") and
                   Item.Oversize
                then
                  Oversize := true;
              until SalesLine.NEXT = 0;

            // Return zero free freight minimum order amount if shipping agent is of pickup type
            if ShippingAgent.Type = ShippingAgent.Type::Pickup then
              exit(0);

            // Return zero free freight minimum order amount if customer is set to get Free Freight
            if Cust.GET(SalesHeader."Sell-to Customer No.") and
               Cust."Free Freight"
            then
              exit(0);

            // Return zero free freight minimum order amount if customer for specific division is set to get Free Freight
            if CustDivision.GET(SalesHeader."Sell-to Customer No.",SalesHeader."Shortcut Dimension 5 Code") and
               CustDivision."Free Freight"
            then
              exit(0);

            // Return free freight minimum order amount for customer and division
            if CustDivision.GET(SalesHeader."Sell-to Customer No.",SalesHeader."Shortcut Dimension 5 Code") and
               (CustDivision."Free Freight Min. Order Amount" <> 0)
            then
              exit(CustDivision."Free Freight Min. Order Amount");

            // Return free freight minimum order amount for specific shipping agent (LOCAL)
            FreeFreightMinOrderAmt.RESET;
            FreeFreightMinOrderAmt.SETRANGE("Division Code",'');
            FreeFreightMinOrderAmt.SETRANGE("Shipping Agent Code",SalesHeader."Shipping Agent Code");
            if FreeFreightMinOrderAmt.FINDFIRST then
              exit(FreeFreightMinOrderAmt."Min. Order Amount");

            // Return free freight minimum order amount for specific division (I) and location (1|25|50)
            FreeFreightMinOrderAmt.RESET;
            FreeFreightMinOrderAmt.SETRANGE("Division Code",SalesHeader."Shortcut Dimension 5 Code");
            FreeFreightMinOrderAmt.SETRANGE("Shipping Agent Code",SalesHeader."Shipping Agent Code");
            FreeFreightMinOrderAmt.SETRANGE("Location Code",SalesHeader."Location Code");
            if FreeFreightMinOrderAmt.FINDFIRST then
              exit(0);

            // Return free freight minimum order amount for specific division (E or L)
            FreeFreightMinOrderAmt.RESET;
            FreeFreightMinOrderAmt.SETRANGE("Division Code",SalesHeader."Shortcut Dimension 5 Code");
            FreeFreightMinOrderAmt.SETRANGE("Location Code",SalesHeader."Location Code");
            FreeFreightMinOrderAmt.SETRANGE(Oversize,Oversize);
            if FreeFreightMinOrderAmt.FINDFIRST then
              exit(FreeFreightMinOrderAmt."Min. Order Amount");

            // Return free freight minimum order amount in other cases (for all other divisions and locations)
            FreeFreightMinOrderAmt.RESET;
            FreeFreightMinOrderAmt.SETRANGE("Division Code",'');
            FreeFreightMinOrderAmt.SETRANGE("Location Code",'');
            FreeFreightMinOrderAmt.SETRANGE(Oversize,Oversize);
            if FreeFreightMinOrderAmt.FINDFIRST then
              exit(FreeFreightMinOrderAmt."Min. Order Amount");

            // Return zero free freight minimum order amount if no conditions for free freight found
            exit(0);
        end;
        */
}

