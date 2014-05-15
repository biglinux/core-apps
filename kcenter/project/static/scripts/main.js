$('a').tooltip();

$('#services a').on('click', function(){
		$.ajax({
			url: "http://127.0.0.1:2222/execute",
			type: "POST",
			data: { service: $(this).attr("data-service") }
		});
});
