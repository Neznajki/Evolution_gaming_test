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
		#log childs;
		if where is false #main container checking
			container = $(@mainContainer);
			addButton = $ '<div/>', {class: 'add'};
			addButton.click this, @add;
			container.append addButton;
			container.append $ '<br/>'
			#log(1);
		else #is child container of other container
			container = @getChildsContainer(where);
			container.removeClass 'hidden';
			#log(2);
			
		#container.html '';
		for ID, data of childs
			if where isnt false
				ID = where + '_' + ID;
			@drawChild ID, data, container;
		#if not empty mainAdd
			
	
	drawChild: (ID,data,container) ->
		#log container;
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

		removeButton = $ '<div/>', {ID: 'del_' + ID,class: 'del'};
		removeButton.click this, @remove;

		container.append branch;
		container.append addButton;
		container.append removeButton;
		container.append childsContainer;

	expand: (event) ->
		self = event.data;
		expandButton = $(this);
		element = expandButton.next();
		elementID = element.attr 'ID';
		if expandButton.hasClass 'expanded'
			expandButton.removeClass 'expanded';
			self.getChildsContainer(elementID).html '';
		else
			self.draw elementID;
			expandButton.addClass 'expanded';
	
	add: (event) ->
		self = event.data;
		#newName = prompt "Please type in name:" ;
		elementID = $(this).attr 'ID';

		new window.DataAsker "Please type in name:", true, self, (newName)->
		#if not empty newName
			if empty elementID
				target = self.getEntry();
				refreshID = false;
				container = $(self.mainContainer);
				#log container;
				#log 1;
			else
				refreshID = elementID.replace /^add_/, '';
				container = self.getChildsContainer(refreshID);
				#log refreshID + ' indexing';
				target = self.getEntry refreshID;
				#log 2;
			
			newEntry = self.createNewEntry(newName);
			
			newElementID = target.length;
			#log newElementID;
			target.push newEntry;
			
			expandButton = self.getExpandButton(refreshID);
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
			
	remove: (event) ->
		self = event.data; #getting class from registered param

		elementID = $(this).attr 'ID';
		removeID = elementID.replace /^del_/, '';
		
		#log removeID + ' indexing remove';
		
		matches = removeID.match(/(.*)_?([0-9]+$)/);
		#log matches;
		
		parentID = matches[1].replace(/_$/,'');
		elementArrayID = parseInt(matches[2]);

		target = self.getEntry parentID or false;
		
		target.splice(elementArrayID,1);
		#log self.treeObject;
		#log parentID;
		if empty target
			self.getExpandButton(parentID).removeClass('expanded').removeClass('withChilds').addClass('noChilds').off('click');
		
		self.getChildsContainer(parentID).html '';
		self.draw(parentID or false);
		#log 2;

	getEntry: (entryName = false) ->
		result = @treeObject;
		#entryName += '';
		#log entryName;
		if entryName isnt false
			#log 'comes in get sub entry';
			sections = entryName.split('_');
			#log sections;
			for depth,section of sections
				result = result[section]['childs'];
				
		return result;
		
	getChildsContainer: (elementID) ->
		if empty elementID
			elementID = @mainContainer
		else
			elementID = '#childs_' + elementID

		return $(elementID);
	
	getExpandButton: (elementID)->
		return $('#' + elementID).prev();

	createNewEntry: (entryName)->
		return {name: entryName, childs: []};