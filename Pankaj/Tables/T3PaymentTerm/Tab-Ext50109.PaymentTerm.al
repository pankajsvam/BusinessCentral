tableextension 50109 PaymentTermExt extends "Payment Terms"
{
    fields
    {
        Field(50005; "Overdue Balance Grace Period"; DateFormula) { }
        Field(50033; "Payment Term Day Range"; Boolean) { }
        Field(51093; "Payment Discount Grace Period"; DateFormula) { }
        Field(51095; "Do Not Allow Blind Shipment"; Boolean) { }
        Field(51096; "Do Not Allow Double Bl. Shpt."; Boolean) { }
        Field(51400; "Type"; Enum PaymentTerm_Type) { }

    }
}
