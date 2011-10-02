// Create the canvas
var canvas = document.createElement("canvas");
var ctx = canvas.getContext("2d");
canvas.width = 1024;
canvas.height = 768;
document.body.appendChild(canvas);

var theme_song = new Audio("../matchtrack.mp3");
var buttons = [];

var onLoadClosure = function( image )
{
    return function() {
         image.loaded = true;
         };
};

var loadart = function ( artindex )
{
    for( key in artindex )
    {  
        var image =  new Image();

        image.loaded = false;
        image.onload = onLoadClosure( image ); 
        image.src = artindex[key].path;

        artindex[key]["image"] = image;   
    }
};

var artloaded = function( artindex )
{
    var isloaded = true; 
    for( key in artindex )
    {  
        if( !artindex[key].image.loaded )
        {
            isloaded = false;
        } 
    }
    return isloaded;
};

var render = function()
{
    ctx.drawImage( artindex.background.image, 0,0  );
};

var render_charselect = function()
{
    ctx.drawImage( artindex.background_char.image, 0,0  );

    render_buttons();
};

var reset_gameplay = function()
{
    buttons = [];
    
    gamestate = "playing"; 
};

var reset_charselect = function()
{
    buttons = [];
   
    image = artindex.avatar_newton; 
    button = {"image": image, 
                "x": 200,
                "y": 150, 
                "width":image.image.width,
                "height":image.image.height,
                "click": function(){ character_select = "newton"; reset_gameplay();} };

    buttons.splice( 0, 0, button);

    button = {"image": image, 
                "x": 550,
                "y": 150, 
                "width":image.image.width,
                "height":image.image.height,
                "click": function(){ character_select = "archimedes"; reset_gameplay();} };

    buttons.splice( 0, 0, button);

    button = {"image": image, 
                "x": 200,
                "y": 415, 
                "width":image.image.width,
                "height":image.image.height,
                "click": function(){ character_select = "einstein"; reset_gameplay();} };

    buttons.splice( 0, 0, button);

    button = {"image": image, 
                "x": 550,
                "y": 415, 
                "width":image.image.width,
                "height":image.image.height,
                "click": function(){ character_select = "curie"; reset_gameplay();}  };

    buttons.splice( 0, 0, button);
    gamestate = 'charselect';
};

var render_intro = function()
{
    ctx.drawImage( artindex.background.image, 0,0  );

    render_buttons();
};

var reset_intro = function()
{
    buttons = [];
    
    button = {"image": artindex.logo_deathmath_nobuttons, 
                "x": 138,
                "y": 138, 
                "width":artindex.logo_deathmath_nobuttons.image.width,
                "height":artindex.logo_deathmath_nobuttons.image.height,
                "click":reset_charselect };
    
    buttons.splice( 0, 0, button);

    gamestate = 'intro';
};

var render_buttons = function()
{
    for( var i = 0; i < buttons.length; i++)
    {
        button = buttons[i]; 
        ctx.drawImage( button.image.image , button.x,  button.y  );
    }
};

var click_check = function( e, button )
{
    if(e.screenX < button.x)  
    {
        return false;
    }
    if(e.screenX > button.x + button.width)  
    {
        return false;
    }
    if(e.screenY < button.y)  
    {
        return false;
    }
    if(e.screenY > button.y + button.height)  
    {
        return false;
    }

    return true;
};

var canvas_click = function(e)
{
    for( var i = 0; i < buttons.length; i++)
    {
        button = buttons[i]; 
        if( click_check(e, button) )
        {
            if(button.click)
            {
                button.click();
                return;
            }
        }
    }
};

var then = Date.now();
var gamestate = 'loading';

// The main game loop
var main = function () {
	var now = Date.now();
	var delta = now - then;

    if(gamestate == 'intro')
    {
	    render_intro();
    }
    else if(gamestate == 'charselect')
    {
	    render_charselect();
    }
    else if(gamestate == 'playing')
    {
	    render();
    }
    else
    {
        if( artloaded( artindex ) )
        {
            reset_intro();
        }
    }

	then = now;
};
loadart( artindex );
setInterval(main, 1);
canvas.onclick = canvas_click;

// theme_song.play();
