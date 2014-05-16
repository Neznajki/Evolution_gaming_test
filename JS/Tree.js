log 'loaded Tree';
class window.Tree
	constructor: (fieldName) ->
		@treeObject = [@createNewEntry fieldName];
		@mainContainer = '#container';
		@draw();
	
	setTree: (@treeObject) ->
		$(@mainContainer).html '';
	getTree: () ->
		return @treeObject;
	
	draw: (where = false) ->
		childs = @getEntry where;
		if where is false #main container checking
			container = $(@mainContainer);
			addButton = $ '<div/>', {class: 'add'};
			addButton.click this, @add;
			container.append addButton;
			container.append $ '<br/>'
			log(1);
		else #is child container of other container
			container = $('#' + where).next().next();
			container.removeClass 'hidden';
			#log(2);
			
		#container.html '';
		for ID, data of childs
			if where isnt false
				ID = where + '_' + ID;
			@drawChild ID, data, container;
		#if not empty mainAdd
			
	
	drawChild: (ID,data,container) ->
		log container;
		name = data.name;
		childs = data.childs;
		branch = $ '<div/>', {ID: ID, text: name, class: 'container'};
		childsContainer = $ '<div/>', {ID: 'childs_' + ID, class: 'hidden childs container'};

		if not empty childs
			expandContainer = $ '<div/>', {class: 'withChilds'};
			expandContainer.click this, @expand;
			container.append expandContainer;
		else
			expandContainer = $ '<div/>', {class: 'noChilds'};
			container.append expandContainer;

		addButton = $ '<div/>', {ID: 'add_' + ID,class: 'add'};
		addButton.click this, @add;

		container.append branch;
		container.append addButton;
		container.append childsContainer;

	expand: (event) ->
		self = event.data;
		expandButton = $(this);
		element = expandButton.next();
		elementID = element.attr 'ID';
		if expandButton.hasClass 'expanded'
			expandButton.removeClass 'expanded';
			element.next().next().html '';
		else
			self.draw elementID;
			expandButton.addClass 'expanded';
	
	add: (event) ->
		self = event.data;
		newName = prompt "Please type in name:" ;
		if not empty newName
			if empty $(this).attr 'ID'
				target = self.getEntry();
				refreshID = false;
				container = $(self.mainContainer);
				log container;
				#log 1;
			else
				elementID = $(this).attr 'ID';
				refreshID = elementID.replace /^add_/, '';
				container = $('#childs_' + refreshID);
				log refreshID + ' indexing';
				target = self.getEntry refreshID;
				#log 2;
			
			newEntry = self.createNewEntry(newName);
			
			newElementID = target.length;
			#log newElementID;
			target.push newEntry;
			
			expandButton = $(this).prev().prev();
			if expandButton.hasClass 'noChilds'
				expandButton.removeClass 'noChilds';
				expandButton.addClass 'withChilds';
				expandButton.click self, self.expand;
			
			if refreshID is false or expandButton.hasClass 'expanded'
				if refreshID is false
					refreshID = newElementID;
				else
					refreshID += '_' + newElementID;
				self.drawChild refreshID, newEntry, container;
			
	getEntry: (entryName = false) ->
		result = @treeObject;
		#entryName += '';
		#log entryName;
		if entryName isnt false
			log 'comes in get sub entry';
			sections = entryName.split('_');
			for depth,section of sections
				result = result[section]['childs'];
				
		return result;
		
	createNewEntry: (entryName)->
		return {name: entryName, childs: []};