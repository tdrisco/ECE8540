
#include <stdio.h>
#include <math.h>
#include <windows.h>
#include <sys/timeb.h>
#include <time.h>


		/*
		** Robot functions
		*/



		/* This robot moves randomly */

void RandomRobot(int FoodClosestDistance,	/* input - closest food in pixels */
			int FoodClosestAngle,		/* input - angle in degrees towards closest food */
			int RobotClosestDistance,	/* input - closest other robot, in pixels */
			int RobotClosestAngle,		/* input - angle in degrees towards closest robot */
			int SharkClosestDistance,	/* input - closest shark in pixels */
			int SharkClosestAngle,		/* input - angle in degrees towards closest shark */
			int CurrentRobotEnergy,		/* input - this robot's current energy (50 - 255) */
			int *RobotMoveAngle,		/* output - angle in degrees to move */
			int *RobotExpendEnergy)		/* output - energy to expend in motion (cannot exceed Current-50) */

{
(*RobotMoveAngle)=(rand() % 360);
if (CurrentRobotEnergy > 50)
  (*RobotExpendEnergy)=(rand() % (CurrentRobotEnergy-50));
else
  (*RobotExpendEnergy)=1;
if ((*RobotExpendEnergy) > 10)
  (*RobotExpendEnergy)=10;
}



		/* This robot moves towards food, ignoring sharks */

void GreedyRobot(int FoodClosestDistance,	/* input - closest food in pixels */
			int FoodClosestAngle,		/* input - angle in degrees towards closest food */
			int RobotClosestDistance,	/* input - closest other robot, in pixels */
			int RobotClosestAngle,		/* input - angle in degrees towards closest robot */
			int SharkClosestDistance,	/* input - closest shark in pixels */
			int SharkClosestAngle,		/* input - angle in degrees towards closest shark */
			int CurrentRobotEnergy,		/* input - this robot's current energy (50 - 255) */
			int *RobotMoveAngle,		/* output - angle in degrees to move */
			int *RobotExpendEnergy)		/* output - energy to expend in motion (cannot exceed Current-50) */

{

	if (SharkClosestDistance < 40)
	{
		(*RobotMoveAngle) = (180 + SharkClosestAngle) % 360;
		(*RobotExpendEnergy) = 30;
	}
	else if (CurrentRobotEnergy < 200)
	{
		(*RobotMoveAngle) = FoodClosestAngle;
		(*RobotExpendEnergy) = 30;
	}
	else if(RobotClosestDistance < 30)
	{
		(*RobotMoveAngle) = RobotClosestAngle;
		(*RobotExpendEnergy) = 10;
	}
	else
	{
		(*RobotMoveAngle) = FoodClosestAngle;
		(*RobotExpendEnergy) = 5;
	}
}



		/* This robot moves away from sharks, ignoring food */

void ScaredRobot(int FoodClosestDistance,	/* input - closest food in pixels */
			int FoodClosestAngle,		/* input - angle in degrees towards closest food */
			int RobotClosestDistance,	/* input - closest other robot, in pixels */
			int RobotClosestAngle,		/* input - angle in degrees towards closest robot */
			int SharkClosestDistance,	/* input - closest shark in pixels */
			int SharkClosestAngle,		/* input - angle in degrees towards closest shark */
			int CurrentRobotEnergy,		/* input - this robot's current energy (50 - 255) */
			int *RobotMoveAngle,		/* output - angle in degrees to move */
			int *RobotExpendEnergy)		/* output - energy to expend in motion (cannot exceed Current-50) */

{
(*RobotMoveAngle)=(180+SharkClosestAngle)%360;
if (SharkClosestDistance < 30)
  (*RobotExpendEnergy)=30;
else
  (*RobotExpendEnergy)=30-SharkClosestDistance/10;
if ((*RobotExpendEnergy) < 3)
  (*RobotExpendEnergy)=3;
}


/* Personal robot*/

void FishAreFriends_NotFood(int FoodClosestDistance,	/* input - closest food in pixels */
	int FoodClosestAngle,		/* input - angle in degrees towards closest food */
	int RobotClosestDistance,	/* input - closest other robot, in pixels */
	int RobotClosestAngle,		/* input - angle in degrees towards closest robot */
	int SharkClosestDistance,	/* input - closest shark in pixels */
	int SharkClosestAngle,		/* input - angle in degrees towards closest shark */
	int CurrentRobotEnergy,		/* input - this robot's current energy (50 - 255) */
	int* RobotMoveAngle,		/* output - angle in degrees to move */
	int* RobotExpendEnergy)		/* output - energy to expend in motion (cannot exceed Current-50) */

{
	
	if (SharkClosestDistance < 100)
	{
		(*RobotMoveAngle) = (180 + SharkClosestAngle) % 360;
		if (CurrentRobotEnergy < 90)
		{
			(*RobotMoveAngle) = FoodClosestAngle;
			(*RobotExpendEnergy) = 20;
		}
		else if (CurrentRobotEnergy < 150)
			(*RobotExpendEnergy) = 25;
		else
			(*RobotExpendEnergy) = 30;
	}
	else if(CurrentRobotEnergy < 120)
	{
		(*RobotMoveAngle) = FoodClosestAngle;
		(*RobotExpendEnergy) = 15;
	}
	else if (SharkClosestDistance > 200)
	{
		(*RobotMoveAngle) = FoodClosestAngle;
		(*RobotExpendEnergy) = 5;
	}
	else if (CurrentRobotEnergy > 200)
	{
		(*RobotMoveAngle) = (180 + SharkClosestAngle) % 360;
		(*RobotExpendEnergy) = 5;
	}
	else
	{
		(*RobotMoveAngle) = FoodClosestAngle;
		(*RobotExpendEnergy) = 7;
	}
}




