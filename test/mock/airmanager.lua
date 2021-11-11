-- ---------------------------------------------------------
-- Mocking Air Manager API functions
-- ---------------------------------------------------------

-- Helper Functions
-------------------
-- log(type, message ) 
-- type :: "INFO" | "WARN" | "ERROR"
-- message :: string
-- mock as 'Spy'
function log(type, message)
  return { level = type, message = message }
end


-- Mock Interface
-----------------
return {
  log = log
}
  