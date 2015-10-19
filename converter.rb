class Converter
	$inputFile
	$inputArray
	$lineCounter=0

	#the converter method is used to convert the given dataset
	#to variable buckets, used for understadning the data after
	#the algorithms are ran.
    def init(file_name)
    	#new input file and new array for the input file are made
    	$inputFile=File.new(file_name,"r")
       	$inputArray=Array.new

       	$inputFile.readlines.each do |line|
       		line.delete!("\n")
			elements=line.split(", ")
			$inputArray<<elements
			$lineCounter=$lineCounter+1
		end

		$inputArray.each do |x|
			x[0]=x[0].to_i
			#x[2]=x[2].to_i
			x[4]=x[4].to_i
			x[10]=x[10].to_i
			x[11]=x[11].to_i
			x[12]=x[12].to_i
		end

		$inputArray.each do |x|
			if x[0]>=1 && x[0]<=20
				x[0]="1-20"
			elsif x[0]>20 && x[0]<=30
				x[0]="21-30"
			elsif x[0]>30 && x[0]<=40
				x[0]="31-40"
			elsif x[0]>40 && x[0]<=50
				x[0]="41-50"
			elsif x[0]>50 && x[0]<=60
				x[0]="51-60"
			elsif x[0]>60 && x[0]<=70
				x[0]="61-70"
			elsif x[0]>70 && x[0]<=80
				x[0]="71-80"
			elsif x[0]>80 && x[0]<=90
				x[0]="81-90"
			elsif x[0]>90 && x[0]<=100
				x[0]="91-100"
			else
				x[0]=x[0].to_s
			end

			if x[4]>=13
				x[4]="bachelorAndUp"
			else 
				x[4]="belowBachelor"	
			end

			if x[12]>20
				x[12]="full"
			else
				x[12]="part"
			end

			#the dataset's capital loss and capital gain are allocated into
			#buckets based on current tax brackets and deductible levels for capital loss.

			# using Tax Rate on Qualified Dividends and Long Term Capital Gains
			#from http://www.schwab.com/public/schwab/nn/articles/Taxes-Whats-New
			if x[10]>=0 && x[10]<=36900
				x[10]="G0%"
			elsif x[10]>36900 && x[10]<=406750
				x[10]="G15%"
			else 
				x[10]="G20%"
			end

			#capital loss from investopedia:
			#Deduction Capital Losses. Fortunately, there is a stipulation for tough times. 
			#You can deduct up to $3,000 worth of losses per year ($1,500 if you file as married filing separately) 
			#and subtract it right off the top of the income you made. That means up to $3,000 of your income will be tax-free that year. 
			#If you had more than $3,000 in capital losses after all your gains were accounted for, 
			#you can actually roll the rest of it (up to another $3,000) into next year’s tax return and deduct it there.
			
			if x[11]>3000
				x[11]="Loss3000orMore"
			else
				x[11]="LossLess3000"
			end

		end	
    end
end

#main calling script for converting the given dataset file
#into a new converted.txt dataset file where variables are put
#into respective bucket classes.
inputFile = ARGV[0]
object=Converter.new
object.init inputFile

puts"#{$inputArray}"

$outputArray=Array.new
count=0

$outputFile=File.new("converted.txt", "w")
for i in 0..$inputArray.length-1
	$inputArray[i].each do |x|
		$outputFile.write("#{x} ")
	end
	$outputFile.write("\n")
end
puts $lineCounter



