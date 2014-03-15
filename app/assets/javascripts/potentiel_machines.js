$(function() {
  initPage();
});
$(window).bind('page:change', function() {
  initPage();
});
function initPage() {
 jQuery(function($) {
  return $("#potentiel_machine_idtype_potentiel").change(function() {
    var state, test, texte;
    state= $("select#potentiel_machine_idtype_potentiel :selected").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get("/type_potentiels/get_unitee.js?pot_id=" + state );
   
    return false;
  });
});

}
