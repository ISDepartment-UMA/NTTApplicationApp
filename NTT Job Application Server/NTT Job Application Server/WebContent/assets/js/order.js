function pruefen()
{

ist_tel=true;	
ist_fax=true;	
tel = document.VCARD.phone.value;
fax = document.VCARD.fax.value;
/* Here international error message should be added */
if(document.VCARD.firstname.value=="") { alert("Bitte tragen Sie einen Vorname ein!"); }
else if(document.VCARD.lastname.value=="") { alert("Bitte tragen Sie einen Nachname ein!"); }
else if(document.VCARD.phone.value=="") { alert("Bitte tragen Sie eine Telefonnummer ein!"); }
else if(document.VCARD.department.value=="") { alert("Bitte tragen Sie einen Bereich ein!"); }
else if (ist_tel==false) { alert("Bitte tragen Sie eine gueltige Durchwahl ein!"); }
else if (ist_fax==false) { alert("Bitte tragen Sie eine gueltige Faxnummer ein!"); }
else if(document.VCARD.email.value=="") { alert("Bitte tragen Sie eine E-Mail-Adresse ein!"); }

}
function validateForm()
{
	var x=document.VCARD.firstname.value;
    if(x=="" || x==null)
    {
      /* alert("User Name should not be left blank");
      document.VCARD.firstname.focus();
      return false; */
      alert("First name must be filled out");
    }
    else 
    {	
    	document.VCARD.action ='BusinessCardOrderServlet'; 
    	document.forms['VCARD'].submit();
    }
}
function testeintrag()
{
	if ( !document.VCARD.firstname.value ) { document.VCARD.firstname.value='Julian'; }
	if ( !document.VCARD.lastname.value ) { document.VCARD.lastname.value='Bradler'; }
	if ( !document.VCARD.title.value ) { document.VCARD.title.value='Diplom-Betriebswirt'; }
	if ( !document.VCARD.department.value ) { document.VCARD.department.value=(unescape("Geschäftsführer")); }
	if ( !document.VCARD.street.value ) { document.VCARD.street.value='Julius-Hatry-Straße 1'; }
	if ( !document.VCARD.zipCode.value ) { document.VCARD.zipCode.value='68163'; }
	if ( !document.VCARD.city.value ) { document.VCARD.city.value='Mannheim'; }
	if ( !document.VCARD.country.value ) { document.VCARD.country.value='Deutschland'; }
	if ( !document.VCARD.company.value ) { document.VCARD.company.value='Bradler GmbH'; }
	if ( !document.VCARD.phone.value ) { document.VCARD.phone.value='0621/4 83 48 530'; }
	if ( !document.VCARD.mobile.value ) { document.VCARD.mobile.value='0176/6 42 91 959'; }
	if ( !document.VCARD.fax.value ) { document.VCARD.fax.value='0621/4 83 48 539'; }
	if ( !document.VCARD.email.value ) { document.VCARD.email.value='julian.bradler@bradler-gmbh.de'; }
	if ( !document.VCARD.website.value ) { document.VCARD.website.value='www.bradler-gmbh.de'; }
	if ( !document.VCARD.salutation.value ) { document.VCARD.salutation.value='Male'; }
 

}
