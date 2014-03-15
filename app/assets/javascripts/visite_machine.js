$(function() {
  initPage();
});
$(window).bind('page:change', function() {
  initPage();
});
function initPage() {
 jQuery(function($) {
  return $("#visite_machine_id_visite_protocolaire").change(function() {
    var state, machine;
    state= $("select#visite_machine_id_visite_protocolaire :selected").val();
    machine =$("select#visite_machine_idmachine :selected").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get("/visite_machines/get_type_visite.js?id_visite_protocolaire=" + state+"&id_machine="+machine );
   
    return false;
  });
});

 jQuery(function($) {
  return $("#visite_machine_idmachine").change(function() {
    var state
    state= $("select#visite_machine_idmachine :selected").val();
    if (state === "") {
      state = "0";
    }
    jQuery.get("/visite_machines/get_type_machine.js?id_machine=" + state );
   
    return false;
  });
});

}
