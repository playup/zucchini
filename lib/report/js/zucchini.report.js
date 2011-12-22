var ci = function() { return $(document.body).hasClass('ci') }

var scrollSurface = function(surface)
{	
	if(ci())
	{
		setTimeout(function()
		{
			surface.animate
			(
				{ left: surface.offset().left - surface.parents('.viewport').width() - 26 },
				1000, 'easeInOutQuint',
				function()
				{												
					if(ci())
					{
						if($('.screen', surface).last().offset().left <= 27)
						{
							setTimeout(function()
							{
								surface.parents('.feature').fadeOut(500, function()
								{									  
									surface[0].style.left = 0
									var next = nextSurface(surface)
									next.parents('.feature').fadeIn(500, function(){ scrollSurface(next) })
								})
							}, 2000)
						}
						else scrollSurface(surface)
					}
				}
			)
		}, 2000)
	}
}

var nextSurface = function(surface)
{
	var next = $('.surface', surface.parents('.feature').next())
	return !next.length ? $('.surface').first() : next
}

var bindEvents = function(callback)
{
	$('.screen').each(function(){ $(this).click(function()
	{
		if(ci())
			$(document.body).switchClass('ci', '', 100, function() { $('.feature').css({ display: 'block' }) })
		else
			$(this).toggleClass('expanded')
	}) })
	
	$('.buttons .expand'  ).click(function(){ $('.screen', $(this).parents('.feature')).addClass(	'expanded') })
	$('.buttons .collapse').click(function(){ $('.screen', $(this).parents('.feature')).removeClass('expanded') })
	
	callback()				
}

$(document).ready(function() { bindEvents(function() { scrollSurface($('.surface').first()) }) })