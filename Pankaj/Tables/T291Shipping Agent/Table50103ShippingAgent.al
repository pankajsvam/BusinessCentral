tableextension 50103 ShippingAgentExt extends "Shipping Agent"
{
    fields
    {
        Field(50000; "Local"; Boolean) { }
        Field(50001; "Pickup"; Boolean) { }
        Field(51000; "Type"; Enum ShippingAgent_Type) { }
        Field(51098; "Blocked"; Boolean) { }
        Field(14000350; "SCAC Code"; Code[10]) { }
        Field(14000351; "Packaging Type"; Code[1]) { }
        //Field(14000701;"Prepaid Freight Type";Option[]){}
        Field(14000702; "Prepaid Freight Code"; Code[20]) { }
        //Field(14000703;"Free Freight Type";Option[]){}
        Field(14000704; "Free Freight Code"; Code[20]) { }
        Field(14000705; "Comment"; Boolean) { }
        //Field(14000709;"Shipper Type";Option[]){}
        Field(14000712; "Additional Markup"; Decimal) { }
        //Field(14000713;"Markup Type";Option[]){}
        Field(14000715; "Disable Rate Calculation"; Boolean) { }
        Field(14000716; "Default E-Ship Agent Service"; Code[30]) { }
        Field(14000717; "Def. Int. E-Ship Agent Service"; Code[30]) { }
        Field(14000719; "Markup on Zero Shipping Cost"; Boolean) { }
        Field(14000720; "Enter Ext. Track. No. on Close"; Boolean) { }
        Field(14000721; "Sales Order Pack Detail"; Boolean) { }
        Field(14000722; "Sales Invoice Pack Detail"; Boolean) { }
        Field(14000723; "Purch. Credit Memo Pack Detail"; Boolean) { }
        Field(14000724; "Purch.Return Order Pack Detail"; Boolean) { }
        Field(14000725; "Transfer Order Pack Detail"; Boolean) { }
        /*Field(14000726;"Package Long Name Type";Option[]){}
        Field(14000727;"Package Long Address Type";Option[]){}
        Field(14000728;"Document Long Name Type";Option[]){}
        Field(14000729;"Document Long Address Type";Option[]){}
        Field(14000730;"Master Data Long Name Type";Option[]){}
        Field(14000731;"Master Data Long Address Type";Option[]){}
        */
        Field(14000732; "Package Dimensions Required"; Boolean) { }
        Field(14000761; "Def. UPS Can. E-Ship Agent Srv"; Code[30]) { }
        Field(14000762; "Def. UPS PR E-Ship Agent Srv."; Code[30]) { }
        Field(14000781; "Location Lookup Address"; Text[250]) { }
        Field(14000782; "Def. FedEx Canadian E-Ship Svc"; Code[30]) { }
        Field(14000783; "FedEx Canadian Shipping Agent"; Boolean) { }
        Field(14000803; "LTL Shipping Agent Account No."; Code[20]) { }
        Field(14000841; "Shipping Label Code"; Code[10]) { }
        Field(14000981; "Require AES ITN for Export"; Boolean) { }
        Field(14000982; "Disable Export Documentation"; Boolean) { }

    }
}