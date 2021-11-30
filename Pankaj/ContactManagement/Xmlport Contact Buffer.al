xmlport 50149 ContactBuffer
{
    Format = VariableText;

    Direction = Both;
    TextEncoding = UTF8;
    UseRequestPage = true;
    TableSeparator = '<NewLine>';
    FieldSeparator = '~';
    FieldDelimiter = '`';
    schema
    {
        textelement(root)
        {
            tableelement(ContactBuffer; "Contact Buffer")
            {
                xmlname = 'ContactBuffer';
                SourceTableView = Sorting(Option, "Option Choice");
                fieldelement(Option; ContactBuffer.Option)
                {

                }
                fieldelement(DefaultText250; ContactBuffer.DefaultText250)
                {

                }
                fieldelement(DefaultText30_1; ContactBuffer."DefaultText 30_1")
                {

                }
                fieldelement(DefaultInteger; ContactBuffer.DefaultInteger)
                {

                }
                fieldelement(Integer1; ContactBuffer.Integer_1)
                {

                }
                fieldelement(DivisionCode; ContactBuffer."Division Code")
                {

                }
                fieldelement(DefaultInteger1; ContactBuffer.DefaultInteger_1)
                {

                }
                fieldelement(DefaultInteger2; ContactBuffer.DefaultInteger_2)
                {

                }
                fieldelement(DefaultInteger3; ContactBuffer.DefaultInteger_3)
                {

                }
                fieldelement(DefaultInteger4; ContactBuffer.DefaultInteger_4)
                {

                }
                fieldelement(DefaultInteger5; ContactBuffer.DefaultInteger_5)
                {

                }
                fieldelement(DefaultInteger6; ContactBuffer.DefaultInteger_6)
                {

                }
                fieldelement(DefaultInteger7; ContactBuffer.DefaultInteger_7)
                {

                }
                fieldelement(DefaultInteger8; ContactBuffer.DefaultInteger_8)
                {

                }
                fieldelement(DefaultInteger9; ContactBuffer.DefaultInteger_9)
                {

                }
                fieldelement(DefaultInteger10; ContactBuffer.DefaultInteger_10)
                {

                }
                fieldelement(DefaultInteger11; ContactBuffer.DefaultInteger_11)
                {

                }
                fieldelement(DefaultInteger12; ContactBuffer.DefaultInteger_12)
                {

                }

            }
        }
    }
}