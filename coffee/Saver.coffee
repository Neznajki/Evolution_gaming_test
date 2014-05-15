class window.Saver
	constructor: (@sessionsContainer) ->
		
	save: (event) ->
		self = event.data;
		if empty self.saveName
			saveName = prompt "Please type in save name:";
		else
			saveName = self.saveName;
		LS = new window.LS self.sessionsContainer;
		existingSaves = LS.load();

		if empty saveName
			noSave = true;
		else if existingSaves[saveName] is true and empty self.saveName
			agreement = prompt "save already exists if you would like override old one push Ok";
			if agreement is null
				noSave = true;

		if empty saveName
			noSave = true;

		if empty noSave
			self.LS = new window.LS saveName;
			existingSaves[saveName] = true;
			LS.save existingSaves;
			self.LS.save Tree.getTree();
			self.generateSelect();
			self.saveName = saveName;
			log self.saveName


	load: () ->
		selectedSave = $('#saveSelector').val();
		if not empty selectedSave
			LS = new window.LS selectedSave
			Tree.setTree LS.load();
			log Tree;
			Tree.draw();

	generateSelect: () ->
		LS = new window.LS @sessionsContainer;
		existingSaves = LS.load();
		saveSelector = $('#saveSelector');
		saveSelector.empty();
		for saveName,exists of existingSaves
			saveSelector.append($('<option></option>').val(saveName).html(saveName));