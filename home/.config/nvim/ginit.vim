if exists('g:GuiLoaded')
	try
		GuiFont! FuraCode\ Nerd\ Font:h16
	catch
		GuiFont! Fira\ Code\ Medium:h16
	endtry
else
	set guifont=FuraCode\ Nerd\ Font\ 16,Fira\ Code\ 16,Monaco\ 16,DejaVu\ Sans\ Mono\ 16
endif

