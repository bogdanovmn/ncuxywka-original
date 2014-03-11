function rand(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;  
}
	
/*
 �����, ����������� ���� - ������������ ��� �������� ��������
*/
Sky = function() {
	this.max_height = function() {
		return window.document.body.clientHeight + document.body.scrollTop + 300;
	}
	
	this.max_width = function() {
		return window.document.body.clientWidth - 70; 
	}
}

/*
 �����, ���������� ��������
*/
SnowFlacke = function(params) {
	params = params || {}
	// ���������
	this.MIN_SPEED = 1
	this.MAX_SPEED = 10
	
	this.MIN_SIZE = 5
	this.MAX_SIZE = 40

	this.sky = new Sky()
	
	this.position = { 
		"x" : params.x || rand(0, this.sky.max_width()),
		"y" : params.y || -1 * rand(10, 1500)
	}

	this.step = params.step || Math.random() * 0.1 + 0.05
	this.cstep = 0
	
	this.image = params.image || "/img/sneg.gif"
	
	// ������������ ���-�� ��������
	SnowFlacke.count++
	
	// ��������� id ��������
	this.id = "si" + SnowFlacke.count
	
	////////////
	// ������ //
	////////////
	
	/*
	 �������������� ��������� ��������
	*/
	this.html_string = function() {
		this.resize()
		return '<img id="' + this.id + '" src="' + this.image + '" style="position:absolute; top:-101px; left:-101px; width:' + this.size + 'px; height:' + this.size + 'px;">'  
	}
	/*
	 �������� ��������
	*/
	this.move = function() {
		this.position.x += this.speed * Math.cos(this.cstep)
		this.position.y += this.speed

		if (this.position.x >= this.sky.max_width()) { 
			this.position.x -= 30; 
		}
		
		if (this.position.y > this.sky.max_height()) { 
			this.revive();
		}
		
		this.html_block().style.left = this.position.x + 'px'; 
		this.html_block().style.top = (this.position.y -  document.body.scrollTop) + 'px'; 
		 
		this.cstep += this.step; 
	}
	/*
	 ������������ ��������
	*/
	this.revive = function() {
		this.position.y = -1 * rand(50, 500); 
		this.position.x = rand(0, this.sky.max_width());  
		
		this.resize();
	}
	/*
	 �������� ������ ��������, � ����� �������� �� ������� ��������������
	*/
	this.resize = function() {
		this.size = rand(this.MIN_SIZE, this.MAX_SIZE);
		// ��� ������ ��������, ��� ������� ��� ������ ������
		this.speed = (this.size * this.MAX_SPEED) / this.MAX_SIZE; 
		// �������� � ���������� �������� ������ ������� ���������� �� ��������
		this.speed += (-1 * rand(0, 1)) * rand(0, this.speed / 4); 
		if (this.speed < 1) this.speed = 1

		if (this.html_block()) {
			this.html_block().style.width = this.size + 'px';
			this.html_block().style.height = this.size + 'px'; 
		}
	}
	/*
	 ���������� ������ �� html-���� ��������
	*/
	this.html_block = function() {
		return document.getElementById(this.id);
	}
}
SnowFlacke.count = 0

/*
 �����, ����������� ��������
*/
SnowFall = function() {
	// ���������
	this.MOVIE_SPEED = 50
	// ���-�� ��������
	this.size = rand(3, 7)
	this.elements = new Array()
	
	////////////
	// ������ //
	////////////
	
	/*
	 �������������� ��������
	*/
	this.init = function() {
		var block = document.createElement("div")
		block.style.position = "absolute"
		block.style.top = "0px"
		block.style.left = "0px"
		
		var html = '<div style="position:relative">' 
		for (i = 0; i < this.size; i++) {
			this.elements[i] = new SnowFlacke()
			html += this.elements[i].html_string()
		}
		block.innerHTML = html + '</div></div>'; 
		document.getElementsByTagName("body")[0].appendChild(block);
	}	
	/*
	 ������� ����� - ��������
	*/
	this.move = function() {
		for (i = 0; i < this.size; i++) {
			this.elements[i].move()
		}
	}
	/*
	*/
	this.run = function() {
		this.init();

		var self = this;
		setInterval(function() { self.move(); }, this.MOVIE_SPEED)
	}
}

