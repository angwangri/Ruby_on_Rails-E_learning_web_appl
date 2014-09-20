   $(document).ready(function(){
    $("#city_select").change(function(){
      var obj = this;
      $.ajax({
        type: "GET",
        url: "/user_details/get_districts",
        data: { city: obj.value}
      })
      .done(function( msg ) { });
    });
});