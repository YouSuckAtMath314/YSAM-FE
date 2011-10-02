// Create the canvas
var canvas = document.createElement("canvas");
var ctx = canvas.getContext("2d");
canvas.width = 1024;
canvas.height = 768;
document.body.appendChild(canvas);

var theme_song = new Audio("../matchtrack.mp3");
var buttons = [];

var playerstate = [
    {"health":0.4},
    {"health":0.8},
]

var player_image = null;

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

var render_health_bar = function(x, y, health, empty_bar, full_bar)
{
    var split = full_bar.image.width * health;
    ctx.drawImage( full_bar.image, 0, 0, split, full_bar.image.height, x,y, split, full_bar.image.height );
    ctx.drawImage( empty_bar.image, split, 0, empty_bar.image.width - split, empty_bar.image.height, x+split, y, empty_bar.image.width - split, empty_bar.image.height );
};

var render_avatar = function(avatar_image, x, y, health)
{
    var frame = Math.round( (1 - health) * 4);
    var topy = avatar_image.frame_height * frame;
    var height = Math.min( avatar_image.image.height - topy, avatar_image.frame_height);
    ctx.drawImage( avatar_image.image, 0, topy , avatar_image.image.width, height, x,y, avatar_image.image.width, height );
};

var render_health = function()
{
    render_health_bar(0,0, playerstate[0].health, artindex.bg_health_empty, artindex.bg_health_full_red);

    render_health_bar(canvas.width - artindex.bg_health_empty.image.width ,0, playerstate[1].health, artindex.bg_health_empty, artindex.bg_health_full_blue);

    render_avatar(player_image, 100, 80, playerstate[0].health );
    render_avatar(player_image, (canvas.width - 100 ) - player_image.image.width, 80, playerstate[1].health );
};

var render_gameplay = function()
{
    ctx.drawImage( artindex.background.image, 0,0 );

    render_buttons();

    render_health();
   
};

var render_charselect = function()
{
    ctx.drawImage( artindex.background.image, 0,0  );

    render_buttons();
};

var reset_gameplay = function()
{
    buttons = [];
    answer_buttons = [];
    
    playerstate = [
        {"health":1.0},
        {"health":1.0}
    ]

    button = {  "x": 322,
                "y": 350, 
                "width":180,
                "height":180,
                "text": "1",
                "click": function()
                            { 
                                playerstate[0].health = Math.max(0.0, playerstate[0].health - 0.1);
                            } 
                    };
 
    buttons.splice( 0, 0, button);

    button = {  "x": 522,
                "y": 350, 
                "width":180,
                "height":180,
                "text": "2",
                "click": function()
                            { 
                                playerstate[1].health = Math.max(0.0, playerstate[1].health - 0.1);
                            } 
                    };
 
    buttons.splice( 0, 0, button);

    button = {  "x": 522,
                "y": 550, 
                "width":180,
                "height":180,
                "text": "3",
                "click": function(){ } };
 
    buttons.splice( 0, 0, button);

    button = {  "x": 322,
                "y": 550, 
                "width":180,
                "height":180,
                "text": "4",
                "click": function(){ } };
 
    buttons.splice( 0, 0, button);
    gamestate = "playing"; 
};

var reset_charselect = function()
{
    buttons = [];
   
    image = artindex.newton; 
    button = {"image": image, 
                "x": 200,
                "y": 200, 
                "width":image.image.width,
                "height":image.frame_height,
                "click": function(){ 
                        character_select = "newton"; 
                        player_image = artindex.newton;
                        reset_gameplay();
                    } 
                };

    buttons.splice( 0, 0, button);

    image = artindex.archimedes; 
    button = {"image": image, 
                "x": 450,
                "y": 200, 
                "width":image.image.width,
                "height":image.frame_height,
                "click": function(){ 
                        character_select = "archimedes"; 
                        player_image = artindex.archimedes;
                        reset_gameplay();
                    } };

    buttons.splice( 0, 0, button);

    image = artindex.einstein; 
    button = {"image": image, 
                "x": 700,
                "y": 200, 
                "width":image.image.width,
                "height":image.frame_height,
                "click": function(){ 
                        character_select = "einstein"; 
                        player_image = artindex.einstein;
                        reset_gameplay();
                    } };

    buttons.splice( 0, 0, button);

    gamestate = 'charselect';
};

var render_intro = function()
{
    ctx.drawImage( artindex.background.image, 0,0 );

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
        if(button.image)
        {
            ctx.drawImage( button.image.image, 0,0, button.width, button.height, button.x, button.y, button.width, button.height  );
        }
        else
        {
            ctx.fillStyle = "rgb(128, 128, 128)";
            ctx.fillRect( button.x, button.y, button.width, button.height );
        }
        if(button.text)
        {
            ctx.font = "bold 100px/120px Arial Rounded MT Bold";
            ctx.fillStyle = "rgb(256, 256, 256)";
            ctx.textBaseline = "top";
            ctx.textAlign = "center";
            ctx.fillText( button.text, button.x + (button.width / 2.0), button.y + button.height * 0.25, button.width, button.height * 0.75 );
        }
    }
};

var click_check = function( e, button )
{
    if(e.x < button.x)  
    {
        return false;
    }
    if(e.x > button.x + button.width)  
    {
        return false;
    }
    if(e.y < button.y)  
    {
        return false;
    }
    if(e.y > button.y + button.height)  
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
	    render_gameplay();
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
setInterval(main, 30);
canvas.onclick = canvas_click;

// theme_song.play();
