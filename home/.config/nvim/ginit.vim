if exists('g:GuiLoaded')
	try
		GuiFont! FiraCode\ Nerd\ Font\ Mono:h16
	catch
		GuiFont! Fira\ Code\ Medium:h16
	endtry
else
	set guifont=FiraCode\ Nerd\ Font:h16,Fira\ Code:h16,Monaco:h16,DejaVu\ Sans\ Mono:h16
endif

