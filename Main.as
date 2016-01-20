package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class Main extends Sprite
	{
		private var ball:MyBall;
		private var array:Array;
		private var box:MyBox;
		private var slide:MySlide;
		private var lose:MyLose;
		private var card:MyCard;
		private var calTemp:Number = 0;
		private var count:int = 0;
		private var mp3:Sound;
		private var go:MyEnter;
		private var playGame:Boolean = false;
		private var intro:MyIntro;
		private var tempArray:int = 0;
		private var tempBoxX:Number = 0;
		private var velocity:Number = 8;

		public function Main()
		{
			init();// constructor code
		}

		private function init():void
		{// initializet the function

			// create a slide 
			slide = new MySlide();
			slide.x = stage.stageWidth / 2;
			slide.y = 390;
			addChild(slide);

			// create boxes
			box = new MyBox();
			tempBoxX = (stage.stageWidth - box.width * 8) / 2;
			array = new Array();
			creatBox();

			// create a ball
			ball = new MyBall();

			ball.x = slide.x;
			ball.y = stage.stageHeight / 2;

			ball.vX = 0;
			ball.vY = velocity;

			addChild(ball);

			// cread card;
			card = new MyCard();
			card.alpha = 0;

			card.x = stage.stageWidth / 2;
			card.y = stage.stageHeight / 2 + card.height;
			calTemp = (stage.stageHeight / 2 + card.height) / 100;

			addChild(card);

			// cread lose
			lose = new MyLose();
			lose.x = stage.stageWidth / 2;
			lose.y = stage.stageHeight / 2;
			lose.alpha = 0;
			lose.visible = false;
			addChild(lose);

			// cread sound
			/*
			mp3 = new Sound();
			mp3.load(new URLRequest("mp3.mp3"));
			mp3.play();
			*/
			
			// cread enter button
			go = new MyEnter();
			go.x = stage.stageWidth - go.width;
			go.y = stage.stageHeight - go.height;
			go.visible = false;

			addChild(go);
			
			intro = new MyIntro();
			intro.x = stage.stageWidth/2;
			intro.y = stage.stageHeight/2 + 25;
			intro.visible = true;
			
			addChild(intro);

			// add the listeners
			addEventListener(Event.ENTER_FRAME, onEnterFrames);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDowns);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUps);

		}

		////////////////////////////////////////////////////////////////////////////

		private function onEnterFrames(events:Event):void
		{


			if (!playGame)
			{
				ball.visible = false;
				go.visible = true;
				go.addEventListener(MouseEvent.CLICK, onMouseClick);

			}
			else
			{
				moveAndCheckSlide();

				if (ball.visible)
				{

					moveTheBall();

					checkBorderBall();

					checkSlideBall();

					checkTheBallBox();

				}
				else if ( !ball.visible && array.length != 0)
				{
					lose.visible = true;
					if (lose.alpha != 1)
					{
						lose.alpha +=  0.05;
					}
					
					go.visible = true;
					go.addEventListener(MouseEvent.CLICK, onMouseClick);
				}

				if ( (array.length == 0) && (card.y >= stage.stageHeight / 2) )
				{
					ball.vX = 0;
					ball.vY = 0;
					ball.visible = false;
					card.y -=  calTemp;
					card.alpha +=  calTemp / 100;
				}
			}
		}

		////////////////////////////////////////////////////////////////////////////

		private function onMouseClick(events:MouseEvent):void
		{
			tempArray = array.length;
			for (var i:int = 0; i < tempArray; i++)
			{
				removeChild(array[i]);
			}
			array.splice(0, tempArray);

			creatBox();
			playGame = true;
			go.visible = false;
			lose.visible = false;
			intro.visible = false;
			ball.visible = true;
			ball.vY = velocity;
			go.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}

		////////////////////////////////////////////////////////////////////////////

		private function onKeyDowns(key:KeyboardEvent):void
		{
			switch (key.keyCode)
			{
				case Keyboard.LEFT :
					slide.vX = -10;
					break;

				case Keyboard.RIGHT :
					slide.vX = 10;
					break;

				default :
					break;
			}
		}

		////////////////////////////////////////////////////////////////////////////

		private function onKeyUps(key:KeyboardEvent):void
		{
			slide.vX = 0;
		}

		////////////////////////////////////////////////////////////////////////////

		private function checkTheBallBox():void
		{
			for (var k:uint = 0; k < array.length; k++)
			{


				if (ball.x > array[k].x - array[k].width / 2 && ball.x < array[k].x + array[k].width / 2 && ball.y > array[k].y - ball.height / 2 - array[k].height / 2 && ball.y < array[k].y)
				{//top test ball box
					ball.y = array[k].y - ball.height / 2 - array[k].height / 2;
					ball.vY =  -  ball.vY;
					ball.x +=  ball.vX;
					ball.y +=  ball.vY;
					removeChild(array[k]);
					array.splice(k, 1);
				}
				else if (ball.x > array[k].x - array[k].width / 2 && ball.x < array[k].x + array[k].width / 2 && ball.y < array[k].y + ball.height / 2 + array[k].height / 2 && ball.y > array[k].y )
				{// bottom test ball box
					ball.y = array[k].y + ball.height / 2 + array[k].height / 2;
					ball.vY =  -  ball.vY;
					ball.x +=  ball.vX;
					ball.y +=  ball.vY;
					removeChild(array[k]);
					array.splice(k, 1);
				}
				else if (ball.y > array[k].y - array[k].height / 2 && ball.y < box.y + array[k].height / 2 && ball.x > array[k].x + ball.width / 2 + array[k].width / 2 && ball.x < array[k].x )
				{//left test ball box
					ball.x = array[k].x - ball.width / 2 - array[k].width / 2;
					ball.vX =  -  ball.vX;
					ball.x +=  ball.vX;
					ball.y +=  ball.vY;
					removeChild(array[k]);
					array.splice(k, 1);
				}
				else if (ball.y > array[k].y - array[k].height / 2 && ball.y < array[k].y + array[k].height / 2 && ball.x < array[k].x + ball.width / 2 + array[k].width / 2 && ball.x > array[k].x )
				{//right test ball box
					ball.x = array[k].x + ball.width / 2 + array[k].width / 2;
					ball.vX =  -  ball.vX;
					ball.x +=  ball.vX;
					ball.y +=  ball.vY;
					removeChild(array[k]);
					array.splice(k, 1);
				}
			}
		}

		////////////////////////////////////////////////////////////////////////////

		private function checkBorderBall():void
		{
			// judge the boundary of the stage X for the ball
			if (ball.x <= ball.width / 2)
			{
				ball.x = ball.width / 2;
				ball.vX =  -  ball.vX;
			}
			else if (ball.x >= stage.stageWidth - ball.width / 2)
			{
				ball.x = stage.stageWidth - ball.width / 2;
				ball.vX =  -  ball.vX;
			}

			// judge the boundary of the stage Y for the ball
			if (ball.y <= ball.height / 2)
			{
				ball.y = ball.height / 2;
				ball.vY =  -  ball.vY;
			}
			else if (ball.y >= stage.stageHeight)
			{
				removeBall();
			}
		}

		////////////////////////////////////////////////////////////////////////////

		private function moveTheBall():void
		{
			//ball moving
			ball.x +=  ball.vX;
			ball.y +=  ball.vY;
		}

		////////////////////////////////////////////////////////////////////////////

		private function moveAndCheckSlide():void
		{
			//slide action moving
			slide.x +=  slide.vX;

			if (slide.x <=  -  slide.width / 2)
			{
				slide.x = stage.stageWidth + slide.width / 2;
			}
			else if (slide.x >= stage.stageWidth + slide.width / 2)
			{
				slide.x =  -  slide.width / 2;
			}
		}

		////////////////////////////////////////////////////////////////////////////

		private function checkSlideBall():void
		{
			// check and reflect ball
			if (ball.x >= slide.x - slide.width / 2 && ball.x <= slide.x + slide.width / 2 && ball.y >= slide.y - ball.height / 2 - slide.height)
			{
				ball.y = slide.y - ball.height / 2 - slide.height;
				ball.vX = Math.sin((ball.x - slide.x) / slide.width * Math.PI / 2) * velocity;
				ball.vY = Math.cos((ball.x - slide.x) / slide.width * Math.PI / 2) * velocity;
				ball.vY =  -  ball.vY;
			}
		}

		////////////////////////////////////////////////////////////////////////////

		private function removeBall():void
		{
			
			ball.x = slide.x;
			ball.y = stage.stageHeight / 2;
			ball.vX = 0;
			ball.vY = 0;
			ball.visible = false;
		}

		////////////////////////////////////////////////////////////////////////////

		private function creatBox():void
		{
			for (var j = 0; j < 4; j++)
			{
				for (var i = 0; i < 8; i++)
				{
					box = new MyBox();
					box.x = tempBoxX + box.width * i + box.width / 2;
					box.y = 20 + j * box.height;
					addChild(box);
					array.push(box);
				}
			}
		}

		////////////////////////////////////////////////////////////////////////////
	}
}