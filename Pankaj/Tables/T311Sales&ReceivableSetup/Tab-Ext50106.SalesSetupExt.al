tableextension 50106 SalesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        Field(50000; "Lost Opportunity Nos."; Code[10]) { }
        Field(50001; "Payment Terms by Division"; Boolean) { }
        Field(50002; "Mfr. Rep. Nos."; Code[10]) { }
        Field(50003; "Sales Line Max. Margin %"; Decimal) { }
        Field(50004; "ASN Report ID"; Integer) { }
        Field(50005; "ASN Report Name"; Text[30]) { }
        Field(50006; "E-Mail Subject"; Text[150]) { }
        Field(50007; "ASN E-Mail Template"; blob) { }
        Field(50008; "Sender Name"; Text[50]) { }
        Field(50009; "Sender E-Mail"; Text[80]) { }
        Field(50010; "ASN Report Path"; Text[250]) { }
        Field(50011; "Enable ASN E-Mail"; Boolean) { }
        Field(50012; "ASN E-Mail Body1"; Text[250]) { }
        Field(50013; "ASN E-Mail Body2"; Text[250]) { }
        Field(50014; "ASN E-Mail Signature Line1"; Text[50]) { }
        Field(50015; "ASN E-Mail Signature Line2"; Text[50]) { }
        Field(50020; "Sales Line Min. Margin %"; Decimal) { }
        Field(50021; "Temp Order Nos."; Code[10]) { }
        Field(50022; "Min Quote Ntf Amount"; Decimal) { }
        Field(50023; "Buffer Quote Nos."; Code[10]) { }
        Field(51006; "Fax Printer Name"; Text[250]) { }
        Field(51007; "Fax Directory"; Text[250]) { }
        Field(51008; "Scaler Document No."; Code[10]) { }
        Field(51013; "G/L Rebate Account No."; Code[20]) { }
        Field(51047; "Validate Cust. Mfr. Rep. Exc."; Boolean) { }
        Field(51096; "Validate Ext. Doc. No. Format"; Boolean) { }
        Field(51109; "Dupl. Whse. Rel. No. Warning"; Boolean) { }
        Field(51110; "Create Posted Whse. Releases"; Boolean) { }
        Field(51145; "Dupl. Ext. Doc. No. Warning"; Boolean) { }
        Field(51160; "Post from Whse. with Job Q."; Boolean) { }
        Field(51161; "Job Q. Prio. for P. from Whse."; Integer) { }
        Field(51162; "Post from Whse. Start Time"; Time) { }
        Field(51163; "Enable Mail"; Boolean) { }
        Field(51164; "Enable Fax"; Boolean) { }
        Field(51165; "Post from Statem. Start Time"; Time) { }
        Field(51166; "Printer Name For Invoice Post"; Text[80]) { }
        Field(51167; "Invoice Notification Start Tim"; Time) { }
        Field(51409; "Split Order F. F. Reason Code"; Code[10]) { }
        Field(51410; "One Location per Order"; Boolean) { }
        Field(51470; "Calc. Free Freight"; Boolean) { }
        Field(51480; "Fright GL Code"; Code[20]) { }
        Field(51481; "XML Internal Doc Nos."; Code[10]) { }
        //Field(14000350; "EDI Software Version"; Option[]){}
        Field(14000601; "Enable Receive"; Boolean) { }
        Field(14000701; "Enable Shipping"; Boolean) { }
        Field(14000702; "Blank Drop Shipm. Qty. to Ship"; Boolean) { }
        Field(14000703; "Allow External Doc. No. Reuse"; Boolean) { }
        //Field(14000704;"E-Ship Locking Optimization";Option[]){}
        Field(14000901; "Enable E-Mail"; Boolean) { }
    }
}
