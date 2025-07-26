print("")
print("Thank you for using the identity validator by RazAPI!")
task.wait(0.3)
print("Starting...")
local function gv(p)local r=getfenv() or getfenv(0) if getgenv then r = getfenv() or getfenv(0) and getgenv() end; while r and p~=""do local k,n=string.match(p,"^([^.]+)%.?(.*)$")r=r[k]p=n end return r end
local ex
if getexecutorname then ex = getexecutorname() else ex = "Unknown" end
local passes, failures, tested = 0, 0, 0

local function As(ok, reason) if not ok then error(reason) end end -- just incase its spoofed
local b = print
local e = warn

local function detected(f: string, t: () -> any)
    task.spawn(function()
        local func = gv(f)
        local success, result = pcall(t)
        if success then
            tested = tested + 1
            passes = passes + 1
            b(string.format("✅ %s • %s", f, tostring(result)))
        else
            failures = failures + 1
            tested = tested + 1
            e(string.format("❌ %s: %s", f, tostring(result)))
        end
    end)
end

local function LogLastMsg()
	return game:GetService("LogService").MessageOut:Wait(), task.wait()
end

task.defer(function()
    b('')
    b(`[ IV ]: Identity Validator results are in for {ex}`)
    b('')
    task.wait(3)
    local s = math.floor((passes/tested)*100)
    local f = math.floor((failures/tested)*100)
    b(string.format("😎 Tested with a %s%% success rate", s))
    b(string.format("💔 Failed over %d%% of tests", f))
    b''
    b'Contributers: RazAPIx64.dll32, danlacho, Acevincente, iusethis'
    b'Verified Executors: NKernel'
    b(game:GetService("HttpService"):GenerateGUID(false))
end)

print("")
print("Testing printidentity...")
print("")

detected("printidentity: Environment Check", function()
   local a,b = pcall(function() if getrenv then As(getrenv().printidentity, 'printidentity does not exist in the Roblox Environment') end end);
   if not getfenv(0).printidentity then As(3>4, 'printidentity was not found in the callers environment') end;
   return "Passed"
end)

--[[detected("printidentity: Validation Check", function()
    local IsC = debug.info(printidentity, 's') == '[C]'
    if not IsC then
        As(3>4, 'printidentity is not a C closure (spoofed)')
    end

    printidentity()
    As(LogLastMsg:find('Current identity is'), 'Did not print anything')
end)]]

print("")
print("Testing getthreadidentity...")
print("")

if getthreadidentity then 

detected("getthreadidentity: Validation Check", function()
    local a,b = pcall(function() if getrenv then As(not getrenv().getthreadidentity, "getthreadidentity should not exist in the Roblox Environment, only the exploit's environment.") end end)
    As(getthreadidentity ~= nil, "getthreadidentity doesn't exist")
    As(type(getthreadidentity()) == "number", "Did not return a number")
    As(getthreadidentity() <= 8, 'Thread identity cannot be more than 8')

    return "Passed"
end)

detected("getthreadidentity: Closure Test", function()
    local a,b = pcall(function() if getgenv then As(getgenv().getthreadidentity, "getthreadidentity is not a global closure") end end)
    As(type(getthreadidentity) == "function", "getthreadidentity is not a function (got "..type(getthreadidentity)..".)")
    As(debug.info(getthreadidentity, 's') == "[C]", "getthreadidentity is not a C Closure")
    
    return "Passed"
end)

if getthreadidentity() > 1 then
    detected("getthreadidentity: GetJobInfo", function()
        local s = pcall(function() return game:GetJobsInfo() end)
        As(s, "Could not get jobinfo (Fake level "..getthreadidentity()..")")
        return "Passed"
    end)
end

if getthreadidentity() > 2 then
    detected("getthreadidentity: Accessing CoreGui", function()
        local s = pcall(function() return game.CoreGui.Name end)
        As(s, "Couldn't access CoreGui (Fake level "..getthreadidentity()..")")
        return "Passed"
    end)
end

if getthreadidentity() > 3 then
    detected("getthreadidentity: Instance.new", function()
        local s = pcall(function() return Instance.new("Player") end)
        As(s, "Couldn't create Player instance (Fake level "..getthreadidentity()..")")
        return "Passed"
    end)
end

if getthreadidentity() == 6 then
    detected("getthreadidentity: Creating a TexturePack:", function()
        local s = pcall(function() return Instance.new("SurfaceAppearance").TexturePack end)
        As(s, "Couldn't create SurfaceAppearance (Fake level "..getthreadidentity()..")")
        return "Passed"
    end)
end

if getthreadidentity() > 7 then
    detected("getthreadidentity: Changing a Instance's offset", function()
        local s = pcall(function() Instance.new("MeshPart").HasJointOffset = false end)
        As(s, " Couldn't change a instance's offset (Fake level "..getthreadidentity()..")")
        return "Passed"
    end)
end

else
    print("")
    warn("[ IV ]: 💔 Failed to test getthreadidentity due to the function missing.")
end

print("")
print("Testing setthreadidentity")
print("")

if setthreadidentity then
  detected("setthreadidentity: Validation Check", function()
     local b = pcall(function() return setthreadidentity(true) end)
     local c = pcall(function() return setthreadidentity(9) end)

     As(setthreadidentity ~= nil, "setthreadidentity doesn't exist");
     As(not b, "setthreadidentity did not error when trying to set a non-numerical value");
     As(not c, 'setthreadidentity did not return an error when trying to set the level to a non-existent internal level')
     return "Passed"
  end)

  detected("setthreadidentity: Closure Check", function()
    local a = pcall(function() setthreadidentity(2) setthreadidentity(3) end)
    As(debug.info(setthreadidentity, 's') == "[C]", "setthreadidentity is not a C Closure");
    As(a, "soo we just wrapping the function in a coroutine now 💔")
    local b = pcall(function() if getgenv then As(getgenv().setthreadidentity, "setthreadidentity is not a global function"); else return "getgenv is missing, Skipping test..." end end)
    return "Passed"
  end)

  detected("setthreadidentity: Checking if the identity can be set", function()
    setthreadidentity(1);
    As(getthreadidentity() == 1, "Did not set the thread identity to 1 (getthreadidentity did not return the valid identity)");
    return "Passed"
  end)

  detected("setthreadidentity: Setting identity to 3", function()
     setthreadidentity(4)
     As(getthreadidentity() == 4, "Did not set the thread identity to 4 (getthreadidentity did not return the valid identity)");
     local a = pcall(function() return Instance.new('Player') end);
     As(a, "Nice fake setthreadidentity that just sets a variable (number) to be the new thread identity 💔")
     return "Passed"
  end)

  detected("setthreadidentity: Setting identity to 4", function()
     setthreadidentity(4)
     local a = pcall(function() return Instance.new("Player") end)
     As(getthreadidentity() == 4, "Did not set the thread identity to 4 (getthreadidentity did not return the valid identity)");
     As(a, "Did not set the thread identity to 4")
  end)
else
    warn("[ IV ]: 💔 Failed to test setthreadidentity due to the function missing.")
end
