table 50204 "Ship-to Address Division"
{
    // version TPZ000.00.00

    // 2015-05-27 TPZ717 VCHERNYA
    //   Table has been created
    // 2015-12-21 TPZ1342 VCHERNYA
    //   Shipping Advice field has been created
    // 2020-10-26 TPZ2959 UCHOUHAN
    //   Added New Field Salesperson Code (OSR Code).

    Caption = 'Ship-to Address Division';
    //DrillDownPageID = "Ship-to Address Divisions";//TODO:
    //LookupPageID = "Ship-to Address Divisions";//TODO:

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            CaptionML = ENU = 'Customer No.',
                        ESM = 'Nº cliente',
                        FRC = 'N° client',
                        ENC = 'Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(2; "Ship-to Code"; Code[10])
        {
            CaptionML = ENU = 'Ship-to Code',
                        ESM = 'Cód. dirección envío cliente',
                        FRC = 'Code de livraison',
                        ENC = 'Ship-to Code';
            NotBlank = true;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
        }
        field(3; "Shortcut Dimension 5 Code"; Code[10])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            NotBlank = true;

            trigger OnLookup();
            begin
                LookupShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(29; "Salesperson Code"; Code[10])
        {
            Caption = 'OSR Code';
            DataClassification = ToBeClassified;
            Description = 'TPZ2959';
            TableRelation = "Salesperson/Purchaser";
        }
        field(31; "Shipping Agent Code"; Code[10])
        {
            CaptionML = ENU = 'Shipping Agent Code',
                        ESM = 'Cód. transportista',
                        FRC = 'Code agent de livraison',
                        ENC = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate();
            begin
                SalesSetup.GET;
                if ("Shipping Agent Code" <> xRec."Shipping Agent Code") and SalesSetup."Enable Shipping" then
                    if "Shipping Agent Code" = '' then
                        "E-Ship Agent Service" := ''
                    else begin
                        ShippingAgent.GET("Shipping Agent Code");
                        ShipToAddr.GET("Customer No.", "Ship-to Code");
                        // VALIDATE(
                        //   "E-Ship Agent Service",
                        //   EShipAgentService.DefaultShipAgentService(ShippingAgent, ShipToAddr."Country/Region Code"));
                    end;
            end;
        }
        field(83; "Location Code"; Code[10])
        {
            CaptionML = ENU = 'Location Code',
                        ESM = 'Cód. almacén',
                        FRC = 'Code d''emplacement',
                        ENC = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(5750; "Shipping Advice"; Option)
        {
            Caption = 'Shipping Advice';
            OptionCaption = 'Partial,Complete,No Back Order';
            OptionMembers = Partial,Complete,"No Back Order";
        }
        field(14000701; "E-Ship Agent Service"; Code[30])
        {
            Caption = 'E-Ship Agent Service';
            // TableRelation = "E-Ship Agent Service".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));

            trigger OnLookup();
            begin
                // TESTFIELD("Shipping Agent Code");
                // ShippingAgent.GET("Shipping Agent Code");
                // ShipToAddr.GET("Customer No.", "Ship-to Code");
                // EShipAgentService.LookupEShipAgentService(ShippingAgent, "E-Ship Agent Service", ShipToAddr."Country/Region Code");
                // if PAGE.RUNMODAL(0, EShipAgentService) = ACTION::LookupOK then
                //     VALIDATE("E-Ship Agent Service", EShipAgentService.Code);
            end;

            trigger OnValidate();
            begin
                if "E-Ship Agent Service" <> '' then begin
                    TESTFIELD("Shipping Agent Code");
                    ShippingAgent.GET("Shipping Agent Code");
                    ShipToAddr.GET("Customer No.", "Ship-to Code");

                    // EShipAgentService.ValidateEShipAgentService(ShippingAgent, "E-Ship Agent Service", ShipToAddr."Country/Region Code");
                end;
            end;
        }
        field(14000702; "Free Freight"; Boolean)
        {
            Caption = 'Free Freight';
        }
        field(14000708; "Shipping Payment Type"; Option)
        {
            Caption = 'Shipping Payment Type';
            OptionCaption = 'Prepaid,Third Party,Freight Collect,Consignee';
            OptionMembers = Prepaid,"Third Party","Freight Collect",Consignee;

            trigger OnValidate();
            begin
                // if ShippingAgent.GET("Shipping Agent Code") then
                //     ShippingAccount.ValidateShippingAccount(
                //       ShippingAgent, "Shipping Payment Type",
                //       ShippingAccount."Ship-to Type"::Customer, "Customer No.", "Ship-to Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Ship-to Code", "Shortcut Dimension 5 Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SalesSetup: Record "Sales & Receivables Setup";
        ShippingAgent: Record "Shipping Agent";
        // EShipAgentService: Record "E-Ship Agent Service";
        ShipToAddr: Record "Ship-to Address";
        // ShippingAccount: Record "Shipping Account";
        DimMgt: Codeunit DimensionManagement;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        OldDimSetID: Integer;
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
    end;
}

