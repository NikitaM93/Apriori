$currentTime=Time.now

class Apriori

	#main read function which reads the converted input file.
	#the original dataset.txt file is convereted by the convereter.rb class
	#where entries of each line are placed into respective buckets.
	#the current readFile method takes the converted.txt file and reads through
	#each line entry, creating object entries from each line.
	def readFile(input)
		main=[]
		entryList=[]
		inputFileObj=File.open(input, "r")
		inputFileObj.readlines.each do |x|
			entryList<<(x)
		end
		entryList.each do |x|
			line=Array.new()
			obj=x.split(" ")
			obj.each do |x|
				line<<(x)
				if $hashMain[x].nil?
					$hashMain[x]=1
				else
					$hashMain[x]+=1
				end
			end
			main<<(line)
		end
		return main
	end

	#helper function for inFreqGen
	def inFreqGenIntraFunc(current)
		$arrayInfreq.each do |y|
				tempSize=(y[0]&current)
				if 2<=tempSize.size
					$tempCounter+=1
				end
			end
	end	

	#method checks whether current itemSet is infrequent. 
	#the helper method inFreqGenIntraFunc is used for checking 
	#for the amount of sub-items within an itemSet.
	def inFreqGen(input)
		i=0
		input.each do |x|
			$tempCounter=0
			
			inFreqGenIntraFunc(x)

			if 0!=$tempCounter
				i+=1
			end
		end
		if input.size==i
			return true
		else
			return false
		end
	end

	#method used for finding count of frequent itemsets.
	#counters are kept for each line and method checks how many times items appear.
	def freqSetGen(input, minimumSupport)
		$newTempArray=Array.new

		input.each do |x|
			i=0
			size=x.size
			$aprioriInput.each do |y|
				row=y
				if size!=1
					match=[]
					x.each do |w|
						y.each do |z|
							if z==w
								match<<w
							end
						end
					end
					temp=match.size
					if size<=temp
						i+=1
					end
				else
					if row.index(x[0])
						i+=1
					end	
				end
			end 
			#the methods checks where the current entry meets the minimumSupport level.
			#when all of its combined count is larger than or equal to the level, 
			#then it is added to the final array output.
			if minimumSupport>i
				tempArray=Array.new
				tempArray<<x
				$arrayInfreq<<tempArray
			else
				$newTempArray<<x
				stringTemp=String.new
				x.each do |temp|
					stringTemp="#{stringTemp} #{temp.to_s}" 
				end
				$outputFileMain.puts "#{stringTemp} :#{i.to_s}"            
				#in the event of error for the current buffer, you could implement flush.	
			end	
		end 
		tempReturn=$newTempArray.sort
		return tempReturn
	end 

	#helper function for freqSetGen
	def flattener(tempArray,a,b)
		tempArray.push(a,b)
		tempArray=tempArray.sort
		tempArray=tempArray.flatten!
		if !$mainArray.include? tempArray
			$mainArray<<tempArray
		end
		return tempArray
	end

	#helper function for freqSetGen
	def flattenerMain(tempArray,a,b)
		tempArray.push(a|b)
		tempArray=tempArray.sort.uniq
		tempArray=tempArray.flatten!
		if !$mainArray.include? tempArray
			$mainArray<<tempArray
		end
		return tempArray
	end

	#method is used for making a new list.
	#the method looks at sets that have not been added to the new list yet
	#and adds them to the $mainArray. When the initial element of the list is the same
	#the method checks whether the last entry is less than the last entry of the preceding line.
	#when this check passes, then the two entries are joined together.
	def listSet(input)
		$mainArray=Array.new()
		counter=1
		@size=input.size

		if input.empty?
			return $mainArray
		else
			input.each do |x| 
				i=counter  

				while i!=@size #checking for combining lists.
					if input[i].size==1
						if x!=input[i]
							$tempArray=Array.new
							#helper method is used where only entries that have not
							#been added yet are added to the list.
							$tempArray=flattener($tempArray,x,input[i])
						end
					#checks whether all indeces are equal. If so, then combines.
					else
						tempArray1=input[i][0..x.size-2]
						tempArray2=x[0..x.size-2]
						
						if tempArray2.eql? tempArray1
							if x[x.size-1]<input[i][input[i].size-1]
								$tempArray=Array.new
								#helper method is used where only entries that have not
								#been added yet are added to the list.
								$tempArray=flattenerMain($tempArray,x,input[i])
							end
						end
					end
					i+=1
				end
				counter+=1
			end
		end
		return $mainArray
	end

end

#main script for running apriori
if ARGV.size!=3
	puts "Please enter (1) inputfile (2) outputfile (3) support level."
end

commandInputMainFile=ARGV[0]
commandOutputMainFile=ARGV[1]
tempObj=ARGV[2].to_i
minimumSupport=tempObj

if !File.exists?(commandInputMainFile)
	abort("Error: file not found.")
end

$hashMain=Hash.new()
$arrayInfreq=Array.new() 
$aprioriInput=Array.new()
aprioriTest=Apriori.new
$minimumSupportMatched=[]

$aprioriInput=aprioriTest.readFile(commandInputMainFile)
#puts"#{$aprioriInput}"
	
$outputFileMain=File.open(commandOutputMainFile, "w+")

$hashMain.keys.each do |x|
	tempCompare=$hashMain[x].to_i
	if minimumSupport<=tempCompare
		$minimumSupportMatched<<x
		$outputFileMain.puts "#{x.to_s} :#{$hashMain[x].to_s}"
		#in the event of error for the current buffer, you could implement flush.	
	end
end

$minimumSupportMatched.sort!
tempItemSetArray=Array.new
$minimumSupportMatched.each do |x|
	tempArray=Array.new
	tempArray<<x
	tempItemSetArray<<tempArray
end

#the data is used and run in listSet to record all frequent itemsets.
tempItemSetArray=aprioriTest.listSet(tempItemSetArray)
tempCounter=1
finalOutputArray=tempItemSetArray

#the final method script that goes through the items and checks for minimumSupport levels.
#afterwards, infrequent item levels are checked for.
freqSetTester=true
while freqSetTester==true
	tempFreqSet=aprioriTest.freqSetGen(finalOutputArray, minimumSupport)
	finalOutputArray=aprioriTest.listSet(tempFreqSet)

	if aprioriTest.inFreqGen(finalOutputArray)
		freqSetTester=false
	end
	tempCounter+=1
end 

$outputFileMain.close
$finishTime=Time.now
puts"-----------------------"
puts"Output generated in output.txt file."
tempTimeVal=($finishTime-$currentTime)
puts "Time Lapse for Apriori: #{tempTimeVal}"
puts"Apriori start: #{$currentTime}"
puts"Apriori end: #{$finishTime}"
puts"-----------------------"

#References:
#http://scg.sdsu.edu/dataset-adult_r/
#http://www.armando.ws/2007/10/apriori-algorithm-ruby/
#http://java.dzone.com/articles/my-implementation-apriori

