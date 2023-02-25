type Cell = (Int,Int)
data MyState = Null | S Cell [Cell] String MyState deriving (Show,Eq)

up:: MyState -> MyState
up (S (x,y) (xs:ys) s m) | x<=0 = Null
						 | otherwise = (S ((x-1) , y) (xs:ys) "up" (S (x,y) (xs:ys) s m))
down:: MyState -> MyState
down (S (x,y) (xs:ys) s m) | x>=3 = Null
						 | otherwise = (S ((x+1) , y) (xs:ys) "down" (S (x,y) (xs:ys) s m))
left:: MyState -> MyState
left (S (x,y) (xs:ys) s m) | y<=0 = Null
						 | otherwise = (S (x , (y-1)) (xs:ys) "left" (S (x,y) (xs:ys) s m))
right:: MyState -> MyState
right (S (x,y) (xs:ys) s m) | y>=3 = Null
						 | otherwise = (S (x , (y+1)) (xs:ys) "right" (S (x,y) (xs:ys) s m))
remove :: [Cell] -> Cell -> [Cell]
remove = \list -> \v -> 
    case list of 
        [] -> error "Element not found!"
        x:xs | v==x -> xs
        x:xs -> x:remove xs v
remnull :: [MyState] -> [MyState]
remnull [] = []
remnull (xs:ys) | xs==Null = remnull ys
				| otherwise = (xs:remnull ys)
pres :: Eq a => a -> [a] -> Bool
pres _ [] = False
pres x (y : ys) = if x == y then True else pres x ys
collect (S (x,y) p s m) | pres (x,y) p = (S (x,y) (remove p (x,y)) "collect" (S (x,y) p s m))
						| otherwise = Null
nextMyStates::MyState -> [MyState]
nextMyStates x = remnull (helper x)
helper :: MyState->[MyState]
helper x = [up x , down x , left x , right x , collect x]	
						  
isGoal::MyState->Bool
isGoal (S (x,y) p s m) | p==[] = True
                       | otherwise = False
search::[MyState] -> MyState
search [] = Null
search (xs:ys) | isGoal xs = xs
			   | otherwise = search  (ys++(nextMyStates xs))

removefir :: [String] -> [String]
removefir (xs:ys) = ys

constructSolution:: MyState -> [String]
constructSolution x = removefir(reverse (helpercon x))

helpercon :: MyState -> [String]
helpercon Null = []
helpercon (S (x,y) p s m) = s : helpercon m

solve :: Cell->[Cell]->[String]
solve (x,y) (xs:ys) = constructSolution(search(nextMyStates(S (x,y) (xs:ys) "" Null)))	
						  

