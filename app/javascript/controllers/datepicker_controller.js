import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  console.log("Controller init")

  window.addEventListener('DOMContentLoaded', changeClass);

  function changeClass(){
  };

  // 'data-provide':"datepicker"

  $(document).ready(function(){
     var options = {
            format: 'dd/mm/yyyy',
            assumeNearbyYear: true,
            todayHighlight: true,
            startDate: "01/01/1995",
            endDate: "0d",
            autoclose: true,
            todayBtn: true,
            orientation: 'bottom left auto',
            container: '#datepicker-container',
            zIndexOffset: 20,
        };
    $('.mydatepicker').datepicker(options);
  });

  console.log("Done")
  

$(".dropdown-menu li div").click(
  function(){

  // Getting selected currency code
  var html = $(this).parent().html();

  console.log(html);

  var tempDiv = document.createElement('div');
  tempDiv.innerHTML = html;
  
  var children = tempDiv.children;
  var code = "";
  console.log("l: " + children.length);

  for (let i=0;i<children.length;i++){
    console.log("i: " + i + " " + children[i].children.length);
    for (let k=children[i].children.length-1; k >= 0; k--){
      if (k == children[i].children.length - 1){
        var res = children[i].children[k].innerHTML;
        console.log("k: " + k);
        console.log("res : " + res + " " + typeof(res));
        children[i].children[k].innerHTML = res;
        code = res;
      }
      else{
        console.log("k: " + k)
        console.log("code : " + res + " " + typeof(code));
        children[i].children[k].innerHTML = code;
      }
    }
  }

  var html2 = tempDiv.outerHTML;

  var currency_from = code;
  var currency_to = code;

  console.log("currency_from: " + code);
  console.log("currency_to: " + code);

  // Resplacing button value with selected from list
  $(this).parents(".dropdown").find('#dropdownMenuButton').html( html2 );               // $(this).text() + '<span class="caret"></span>' 
  $(this).parents(".dropdown").find('#dropdownMenuButton').val($(this).data('value'));


  $(this).parents(".dropdown").find('#params_from').val(currency_from);
  $(this).parents(".dropdown").find('#params_to').val(currency_to);
  
});

function isNumber(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if ( (charCode > 31 && charCode < 48) || charCode > 57) {
            return false;
        }
        return true;
    }

  console.log("End");
  

  }
}
