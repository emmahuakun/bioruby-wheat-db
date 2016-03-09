require_relative "../LoadFunctions.rb"
require 'bio'
require 'bio-samtools'
require 'bioruby-polyploid-tools'
require 'csv'  

namespace :mutation do
  desc "Laod snps, from the following header 'Chrom/Scaffold	Pos	Ref	TotCov	WT	MA	Lib	Ho/He	WTCov	MACov	Type	LCov	#libs	InsertType	multimap' It only inserts each position once, however it doesn't validate if the position already exists. It only uses: scaffold, position, ref, wt, alt"
  task :loadSNPs, [:filename] => :environment do |t, args|
  	ActiveRecord::Base.transaction do
  		 File.open(args[:filename]) do |stream|
  			LoadFunctions.insert_snps(stream)
  		end
  	end
  end


  desc "Laod mutations, from the following header 'Chrom/Scaffold	Pos	Ref	TotCov	WT	MA	Lib	Ho/He	WTCov	MACov	Type	LCov	#libs	InsertType	multimap' It only inserts each position once, however it doesn't validate if the position already exists. It only uses: scaffold, position, ref, wt, alt"
  task :load, [:filename] => :environment do |t, args|
  	ActiveRecord::Base.transaction do
  		 File.open(args[:filename]) do |stream|
  			LoadFunctions.insert_mutations(stream)
  		end
  	end
  end

  desc "Load the mutant lines. The file must have the following headers: 'MutantName	library	line	species	Type'"
  task :load_lines_libraries, [:filename] => :environment do |t, args|
  	ActiveRecord::Base.transaction do
  		File.open(args[:filename], "r") do |stream|  
  			LoadFunctions.load_mutant_libraries(stream)
  		end
  	end
  end

  desc "Load the scaffolds with deleted exons. The file must have the following headers: 'MutantName	library	line	species	Type'"
  task :load_deleted_scaffolds, [:filename] => :environment do |t, args|
  	ActiveRecord::Base.transaction do
  		File.open(args[:filename], "r") do |stream|  
  			LoadFunctions.load_deleted_scaffolds(stream)
  		end
  	end
  end

  desc 'Load the mutant lines. The file must have the following headers: "Exon","Library","NormCov","HomDel","HetDel1","Scaffold","Start"'
  task :load_deleted_exons_gz, [:filename] => :environment do |t, args|
  	ActiveRecord::Base.transaction do
  		Zlib::GzipReader.open(args[:filename]) do |stream|
  			LoadFunctions.load_deleted_exons(stream)
  		end
  	end
  end

end