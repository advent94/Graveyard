# Graveyard
Graveyard for dead ideas, hopes and dreams (unused code)

1. Dynamic Shaders

This idea was very ambitious. This was supposed to be system that enables any visual effect on fly, including making changes in
shader code. As ambitious, interesting and fun idea it was, it fell flat. 

Implementation was not an issue, it was fun small challenge. I had all pieces together:
ShaderRecipes that were generating code for canvas_item (2D shader basically) with vertex and fragment body. 
I implemented it in a way so you could add new uniforms, shader code snippets (for vertex and fragment shader accordingly) with 
little to no cost. Biggest cost I estimated would be String generation and because of that, I made constructor basically 
accept arrays of snippets and uniforms. It was done so I would recommend filling recipe before generating script and so script 
wouldn't be generated each time we add a new effect (if we wanted to add many at once, it would end up being called multiple 
times, waste).These arrays or rather directories of effects to arrays were essential to enable switching position between effects 
(two different effects applied at different order could give us two different results). There was also removal of unused effects 
planned/partially implemented, along with periodical uniform update. Code is not clean as I usually make idea, then PoC and then
code ready for production and some tests if I find it necessary.

Now reason why it flopped is simple one, assigning new code to Shader property is very expensive operation. It requires shader
to recompile during runtime (I was trying to squeeze it to single frame at first). It wasn't easy to spot as it caused frame
spike to like 100-400ms (depending on number of entities rendered with effects at once). It was one frame but still, GPU
doesn't like that. I might get away with some recompilation paying high cost but that's not ideal. I thought about making 
dynamic estimations how many different effects I can process in one frame, making a queue and processing requests in chunks
but it doesn't strike me as good solution. Even before that I knew that I need to take to account entities using same shader group
but with different uniforms. Now copying same code or at least generating it would be pointless so I knew I am going to do some
material/shader copying. And this idea is kind of going to be incorporated to next solution which is going to be Uber Shader.

Uber shader is a shader program that contains multiple outcomes/branches. If we don't make it so different fragment can get different
result, we will get this branch check and operations for little to no cost. We will still use outside system to manage effects and
describe how we are going to apply them, which effect is unique, which effect can be repetitive and so on. We still need to hold
information about uniforms, use counters, dynamic timers and so on so initial solution is going to be partially implemented into 
project's Visual Effects system.
