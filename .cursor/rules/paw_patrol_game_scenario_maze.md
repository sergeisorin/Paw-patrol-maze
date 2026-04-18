# Paw Patrol Maze Adventure - AI Agent Game Scenario

## 1. Overview

**Game type:** Preschool maze adventure  
**Target age:** 4 years old  
**Theme:** Paw Patrol  
**Core mechanic:** Simple, friendly mazes with light story progression  
**Player fantasy:** Help the Paw Patrol reach friends in need by guiding a pup through colorful mazes  
**Session length:** 3-7 minutes per maze, 15-25 minutes per full play session  
**Tone:** Safe, cheerful, encouraging, heroic, playful  

This document is designed for an AI agent that generates or runs kid-friendly maze experiences. The game should feel like an interactive cartoon episode where the child helps the Paw Patrol solve rescue missions by navigating through easy mazes.

---

## 2. Design Goals

1. Make the child feel smart and successful quickly.
2. Keep controls and choices extremely simple.
3. Use mazes as the main activity, but wrap every maze in a short Paw Patrol-style rescue story.
4. Avoid fear, failure, punishment, time pressure, and overstimulation.
5. Reward exploration with happy sounds, praise, stickers, badges, or small visual celebrations.
6. Keep mission goals obvious: "Find the farmer", "Bring the hose", "Reach the kitten", "Get to the lookout".

---

## 3. Core Game Loop

Each level follows this loop:

1. **Mission intro**  
   A very short story scene explains who needs help.

2. **Choose a pup**  
   The player selects a Paw Patrol character that matches the mission theme.

3. **Enter the maze**  
   The player moves through a simple maze with wide paths, big landmarks, and friendly visual cues.

4. **Collect helper items**  
   Optional items are placed along the route, such as bones, badges, tools, or treats.

5. **Reach the rescue goal**  
   The player reaches the friend, object, or location at the end of the maze.

6. **Celebrate success**  
   The rescued character smiles, the pup cheers, and the game gives a simple line of praise.

7. **Move to next rescue**  
   The next mission increases novelty, not difficulty.

---

## 4. Preschool Maze Design Rules

These rules are critical for a 4-year-old audience.

### Maze Structure
- Use **small mazes** with very few branches.
- Prefer **3 to 6 decision points** per maze.
- Use **short dead ends** only.
- Dead ends should include a fun surprise, collectible, or visual joke so they do not feel like failure.
- Always ensure the goal is reachable in under 1-2 minutes for first-time players.
- Path width should feel generous and readable.

### Visual Readability
- Use clear path borders.
- Strong contrast between path and walls.
- Large goal object visible from some sections of the maze.
- Landmarks should help orientation: tower, tree, bridge, barn, water tower, beach umbrella, lighthouse.
- Avoid clutter and visual noise.

### Difficulty Rules
- No timers.
- No enemies chasing the player.
- No health, damage, or losing.
- No negative audio cues for wrong turns.
- If the child pauses, a gentle hint may appear.
- If the child takes a wrong turn, reward curiosity rather than punish it.

### Controls
- Tap destination or drag/follow path.
- Optional arrow buttons with large hit areas.
- Only one active mechanic at a time.

---

## 5. Story Premise

A bright morning begins in Adventure Bay. Ryder calls the Paw Patrol because several little friends around town need help. But today, the roads are twisty, the parks are winding, and the paths are confusing. The child helps the pups solve each rescue by guiding them through friendly mazes.

The story should feel episodic. Each maze is a mini rescue mission.

**Core narrative line:**  
"Adventure Bay is full of twisty paths today. Let’s help the Paw Patrol find the way!"

---

## 6. Main Characters

### Ryder
- Role: Mission giver
- Personality: Calm, friendly, supportive
- Use: Introduces each rescue in one short sentence

### Chase
- Theme: City streets, traffic cones, police paths
- Mission style: Find lost items, guide people home, reach a safe place
- Visual cues: Blue paw signs, badges, road markers

### Marshall
- Theme: Fire station, hoses, ladders, rescue routes
- Mission style: Bring water, reach a campfire, help at the barn
- Visual cues: Red hydrants, fire helmets, hose icons

### Skye
- Theme: Gardens, clouds, balloon paths, windy trails
- Mission style: Reach high places, find birds, rescue small animals
- Visual cues: Pink ribbons, feathers, balloons, cloud icons

### Rubble
- Theme: Construction yard, dirt roads, dig paths
- Mission style: Move toward building sites, help repair paths
- Visual cues: Yellow helmets, cones, bricks, digger signs

### Zuma
- Theme: Beach, docks, puddles, riverside paths
- Mission style: Reach floating toys, help by the water, find sea friends
- Visual cues: Orange buoys, shells, fish, water splashes

### Rocky
- Theme: Recycling yard, gadget paths, green gardens
- Mission style: Deliver tools, fix things, find reusable parts
- Visual cues: Green arrows, tools, wheels, recycle signs

---

## 7. World Structure

The game is divided into themed rescue zones. Each zone contains 2-4 mazes.

### Zone 1: Adventure Bay Town
- Bright streets
- Sidewalks with paw prints
- Little parks
- Mailboxes, lamp posts, crosswalks
- Best for Chase missions

### Zone 2: The Farm Paths
- Barns, hay bales, fences, puddles
- Chickens, sheep, tractors
- Curvy dirt paths
- Best for Marshall and Rubble missions

### Zone 3: Seaside Maze
- Sand paths
- Wooden docks
- Beach umbrellas
- Gentle waves and shells
- Best for Zuma missions

### Zone 4: Garden and Sky Trails
- Flower hedges
- Butterfly loops
- Floating balloon markers
- Friendly birdhouses
- Best for Skye missions

### Zone 5: Builder Yard
- Safe construction routes
- Big tires, toy cranes, cones
- Chunky paths through building materials
- Best for Rubble and Rocky missions

### Zone 6: Lookout Hill
- Spiral path up the hill
- Flags, lookout signs, bright viewpoints
- Final celebration maze
- Best for team mission ending

---

## 8. Level Narrative Structure

Use this format for every maze.

### Level flow template
- **Intro line:** Ryder explains the problem in 1 sentence.
- **Pup line:** The chosen pup says a cheerful confidence line.
- **Maze goal:** Reach a friend, item, or destination.
- **Optional collectibles:** 3-5 easy pickups.
- **Hint landmark:** One strong visual element helps guide the player.
- **Success line:** Short celebratory sentence.

---

## 9. Sample Maze Missions

## Mission 1: Chase and the Lost Balloon

**Narrative:**  
A little boy at the town park lost his big blue balloon. It floated across the twisty park paths. Chase needs help finding it.

**Maze goal:** Reach the balloon at the center gazebo.

**Environment:**
- Green park hedges
- Benches
- Blue paw signs
- Small fountain
- Curved stone paths

**Maze style:**
- Very easy introduction maze
- Few branches
- Goal visible from some angles

**Optional collectibles:**
- 3 police badges
- 2 blue bones

**Visual guide:**
- Use bright blue accents
- Balloon visible bobbing above walls sometimes
- Rounded hedge corners
- Friendly ducks near fountain

**Success moment:**
Chase catches the balloon and brings it back. The boy smiles and claps.

**Voice line style:**  
"Great job! We found the balloon!"

---

## Mission 2: Marshall Brings the Water Hose

**Narrative:**  
Farmer Yumi needs help watering the garden. The hose cart is at the other side of the farm path maze.

**Maze goal:** Reach the hose cart and then exit toward the garden.

**Environment:**
- Barn walls
- Hay bales
- Mud puddles
- Flower rows
- Wooden fence corners

**Maze style:**
- Slightly longer path
- Two short dead ends with fun animations

**Optional collectibles:**
- Fire helmets
- Paw prints in the mud
- Water drops

**Visual guide:**
- Red and warm farm colors
- Hose reel glows slightly
- Sunflowers help point in the right direction

**Success moment:**
Marshall reaches the hose, waters the flowers, and everyone cheers.

**Voice line style:**  
"You helped Marshall save the flowers!"

---

## Mission 3: Skye and the Butterfly Garden

**Narrative:**  
A tiny kitten wandered into the butterfly garden and cannot find the way out. Skye needs help reaching it.

**Maze goal:** Reach the kitten in the flower circle.

**Environment:**
- Pink flowers
- Butterfly arches
- Cloud signs
- Soft grassy paths
- Birdhouses

**Maze style:**
- Circular maze feel
- Several loops, but still simple
- Strong color-coded landmarks

**Optional collectibles:**
- Butterflies
- Pink stars
- Tiny bows

**Visual guide:**
- Pastel pink, purple, sky blue
- Gentle flutter animations
- Flower archways mark correct routes

**Success moment:**
The kitten purrs and Skye guides it back home.

**Voice line style:**  
"Awesome flying teamwork!"

---

## Mission 4: Zuma and the Dock Maze

**Narrative:**  
A toy boat drifted to the far dock. Zuma needs help crossing the seaside maze to get it.

**Maze goal:** Reach the toy boat at the dock end.

**Environment:**
- Wooden walkways
- Sand paths
- Orange buoys
- Starfish
- Friendly seagulls

**Maze style:**
- Clear path edges
- Gentle branches
- Some water sparkle distractions

**Optional collectibles:**
- Shells
- Fish tokens
- Orange life rings

**Visual guide:**
- Orange and turquoise accents
- Water animations remain calm, never distracting
- Dock posts create readable corridor rhythm

**Success moment:**
Zuma returns the toy boat and splashes happily.

**Voice line style:**  
"Let’s dive into another rescue!"

---

## Mission 5: Rubble Fixes the Road

**Narrative:**  
A little path to the playground is blocked. Rubble must bring the repair kit through the builder maze.

**Maze goal:** Reach the toolbox and then the blocked road.

**Environment:**
- Toy bricks
- Cones
- Construction signs
- Sand piles
- Safe wooden ramps

**Maze style:**
- Chunky geometric paths
- Slightly more decision points
- Still easy and readable

**Optional collectibles:**
- Wrenches
- Hard hats
- Golden bolts

**Visual guide:**
- Yellow, orange, brown palette
- Big simple shapes
- Toolbox shines softly

**Success moment:**
Rubble repairs the path and kids can reach the playground again.

**Voice line style:**  
"Rubble on the double! We did it!"

---

## Mission 6: Rocky’s Recycling Rescue

**Narrative:**  
The park cleanup cart is lost in the recycling garden maze. Rocky needs help finding it.

**Maze goal:** Reach the recycling cart.

**Environment:**
- Green hedge walls
- Recycle bins
- Tool benches
- Flower patches
- Wind spinners

**Maze style:**
- Simple grid maze
- Repeating shapes balanced with strong markers

**Optional collectibles:**
- Recycle symbols
- Nuts and bolts
- Green bones

**Visual guide:**
- Green and teal palette
- Arrow signs point gently
- Wind spinners animate in calm loops

**Success moment:**
Rocky finds the cart and helps clean the park.

**Voice line style:**  
"Don’t lose it, reuse it! Nice job!"

---

## Mission 7: Team Maze to the Lookout

**Narrative:**  
All the pups are called back to the Lookout for a big celebration. The child guides the team through the final hill maze.

**Maze goal:** Reach the Lookout tower at the top of the hill.

**Environment:**
- Flags
- Spiral hill path
- Trees
- Team banners
- Confetti machines near finish

**Maze style:**
- Longest maze in the game
- Still very manageable
- Several visible checkpoints

**Optional collectibles:**
- Team badges
- Pup treats
- Colorful stars

**Visual guide:**
- Bright team color palette
- Lookout tower always partly visible
- Celebration lights near ending

**Success moment:**
All pups cheer together. Ryder thanks the player for helping every rescue.

**Voice line style:**  
"Paw Patrol is ready to celebrate you!"

---

## 10. Maze Generation Rules for the AI Agent

Use these rules if the AI agent generates new levels dynamically.

### Layout Rules
- Generate mazes with one clear start and one clear goal.
- Maximum overall complexity should remain low.
- Use child-readable shapes: loops, C-shapes, gentle zigzags, spirals, plus-sign intersections.
- Avoid narrow passages.
- Avoid long identical corridors.
- Include one major landmark every 20-30% of progress.

### Goal Placement Rules
- Place the goal in a visually distinct area.
- Let the player preview the goal at least once if possible.
- The goal object should be large, animated, and emotionally positive.

### Collectible Placement Rules
- Put collectibles on the main route often.
- Place some collectibles in short dead ends to make exploration rewarding.
- Never require collecting everything to finish.

### Hint Rules
- If inactivity lasts 5-8 seconds, highlight nearby path direction subtly.
- Hints can include sparkling paw prints, glowing arrow signs, or a pup voice cue.
- Hints should never sound like correction or failure.

### Emotional Rules
- Every wrong turn should still feel interesting.
- Every level should have at least 3 moments of delight: a funny animal, a shiny collectible, a happy animation, or a character voice line.

---

## 11. Visual Direction

## Art Style
- Soft 3D cartoon or polished 2D cartoon
- Large readable shapes
- Thick outlines or clear separation between objects
- Warm, saturated but not overwhelming colors
- Friendly facial expressions
- No dark shadows or scary spaces

## Camera
- Top-down or angled top-down view works best
- Camera should show enough of the maze to support orientation
- Slight zoom out for older preschoolers, closer zoom for easier readability

## Shapes
- Rounded corners everywhere
- Soft hedge walls, chunky fences, wide paths
- Big simple props rather than realistic clutter

## Animation
- Slow looping idle motions
- Waving flags, floating balloons, blinking lights, fluttering butterflies
- Avoid fast movement or flashing effects

## UI
- Large buttons
- Minimal text
- Character portraits for selection
- Goal icon always visible on screen edge if off-screen

---

## 12. Audio Direction

- Use upbeat, playful background music
- Keep tracks gentle and repetitive without becoming noisy
- Use positive sound effects for movement, pickups, success, and hints
- Character voice lines should be very short
- Avoid buzzers, alarms, or negative sounds

### Audio examples
- Collectible pickup: small happy chime
- Goal reached: cheer + sparkle sound
- Hint activated: soft paw-print twinkle
- Success screen: mini fanfare

---

## 13. Rewards and Progression

### Reward Types
- Stickers
- Pup badges
- Rescue stars
- Short celebration scene
- Unlockable environment decorations

### Progression Rules
- Progress should feel horizontal, not punishingly vertical
- New levels introduce new scenery and story goals more than higher difficulty
- The child should unlock new pups and themed mazes quickly

### Suggested Progression
- First 2 mazes: extremely easy onboarding
- Next 3 mazes: slightly longer with more landmarks
- Final team maze: feels grand but stays simple

---

## 14. Safety and Emotional Guardrails

- No villains needed for core gameplay
- No sense of danger, fear, or failure
- Rescues should feel gentle: lost toy, lost path, mixed-up garden, missing tool
- Never imply harm, panic, or emergency intensity
- Keep all story stakes small and comforting

---

## 15. Reusable AI Prompt Template

Use this template to generate more maze missions.

```md
Create a preschool Paw Patrol maze mission for a 4-year-old.

Requirements:
- One short mission story
- One selected pup
- One simple maze goal
- One environment theme
- 3 to 5 optional collectibles
- One major visual landmark
- Positive success ending
- No fear, no enemies, no timer
- Maze should be easy, readable, and cheerful

Output format:
1. Mission title
2. Story setup
3. Chosen pup
4. Maze goal
5. Environment description
6. Maze layout style
7. Collectibles
8. Visual guide
9. Success moment
10. Optional hint behavior
```

---

## 16. Structured Output Schema for an AI Agent

```yaml
game:
  title: "Paw Patrol Maze Adventure"
  audience_age: 4
  genre: "preschool maze adventure"
  theme: "Paw Patrol"
  tone: "cheerful, safe, supportive"

level_template:
  intro_line: "short mission setup"
  chosen_pup: "character name"
  maze_goal: "reach item, friend, or location"
  environment_theme: "town, farm, beach, garden, yard, hill"
  maze_layout_style: "very easy, simple branches, visible landmarks"
  collectibles:
    - "item 1"
    - "item 2"
    - "item 3"
  landmark: "clear visual guide"
  hint_behavior: "gentle paw-print sparkle after inactivity"
  success_line: "short celebration line"

maze_constraints:
  max_decision_points: 6
  no_timer: true
  no_enemies: true
  no_fail_state: true
  dead_ends_allowed: true
  dead_ends_must_be_short: true
  collectible_completion_required: false
  hint_after_seconds_idle: 6

visual_style:
  camera: "top-down or angled top-down"
  colors: "bright, warm, readable"
  shape_language: "rounded, chunky, simple"
  effects: "gentle sparkles, calm motion"
  ui: "large buttons, minimal text"
```

---

## 17. Short Creative Direction Summary

This game should feel like guiding a favorite cartoon hero through a toy-box labyrinth. The maze is the main gameplay, but the emotional experience is rescue, discovery, and celebration. Every level should say to the child: "You found the way, and you helped a friend."

