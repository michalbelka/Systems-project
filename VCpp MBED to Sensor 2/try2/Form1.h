#pragma once

namespace try2 {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;

	using namespace System::IO::Ports;			// *** added to allow listing of COM ports
	using namespace System::Threading;          // *** added to allow access to Sleep command

	/// <summary>
	/// Summary for Form1
	/// </summary>
	public ref class Form1 : public System::Windows::Forms::Form
	{
	public:
		Form1(void)
		{
			InitializeComponent();
			//
			//TODO: Add the constructor code here
			//
		}

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~Form1()
		{
			if (components)
			{
				delete components;
			}
		}
	private: System::Windows::Forms::ComboBox^  comboBox1;
	protected: 
	private: System::Windows::Forms::Button^  initButton;
	private: System::IO::Ports::SerialPort^  serialPort1;
	private: System::ComponentModel::IContainer^  components;
	private: System::Windows::Forms::TextBox^  textBox1;
	private: System::Windows::Forms::Button^  goButton;
	private: System::Windows::Forms::GroupBox^  groupBox1;
	private: System::Windows::Forms::Button^  readCard;

	private: System::Windows::Forms::GroupBox^  groupBox2;
	private: System::Windows::Forms::GroupBox^  groupBox3;
	private: System::Windows::Forms::Label^  label1;
	private: System::Windows::Forms::ComboBox^  rgb;
	private: System::Windows::Forms::Button^  dispenseGo;
	private: System::Windows::Forms::NumericUpDown^  coinsNo;


	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>

//**********************************************************************************************************
// Added programmer variables
//**********************************************************************************************************
	private:
		int					global_error;	// *** added to create an error variable

//**********************************************************************************************************
// Added programmer constant definitions
//**********************************************************************************************************
#define		OK				 0
#define		FORMAT_ERROR	-1
//**********************************************************************************************************


#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			this->components = (gcnew System::ComponentModel::Container());
			this->comboBox1 = (gcnew System::Windows::Forms::ComboBox());
			this->initButton = (gcnew System::Windows::Forms::Button());
			this->serialPort1 = (gcnew System::IO::Ports::SerialPort(this->components));
			this->textBox1 = (gcnew System::Windows::Forms::TextBox());
			this->goButton = (gcnew System::Windows::Forms::Button());
			this->groupBox1 = (gcnew System::Windows::Forms::GroupBox());
			this->readCard = (gcnew System::Windows::Forms::Button());
			this->groupBox2 = (gcnew System::Windows::Forms::GroupBox());
			this->groupBox3 = (gcnew System::Windows::Forms::GroupBox());
			this->label1 = (gcnew System::Windows::Forms::Label());
			this->rgb = (gcnew System::Windows::Forms::ComboBox());
			this->dispenseGo = (gcnew System::Windows::Forms::Button());
			this->coinsNo = (gcnew System::Windows::Forms::NumericUpDown());
			this->groupBox1->SuspendLayout();
			this->groupBox2->SuspendLayout();
			this->groupBox3->SuspendLayout();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->coinsNo))->BeginInit();
			this->SuspendLayout();
			// 
			// comboBox1
			// 
			this->comboBox1->FormattingEnabled = true;
			this->comboBox1->Location = System::Drawing::Point(20, 19);
			this->comboBox1->Name = L"comboBox1";
			this->comboBox1->Size = System::Drawing::Size(121, 21);
			this->comboBox1->TabIndex = 0;
			// 
			// initButton
			// 
			this->initButton->Location = System::Drawing::Point(20, 47);
			this->initButton->Name = L"initButton";
			this->initButton->Size = System::Drawing::Size(121, 23);
			this->initButton->TabIndex = 1;
			this->initButton->Text = L"Init";
			this->initButton->UseVisualStyleBackColor = true;
			this->initButton->Click += gcnew System::EventHandler(this, &Form1::initButton_Click);
			// 
			// textBox1
			// 
			this->textBox1->Location = System::Drawing::Point(332, 21);
			this->textBox1->Multiline = true;
			this->textBox1->Name = L"textBox1";
			this->textBox1->ScrollBars = System::Windows::Forms::ScrollBars::Vertical;
			this->textBox1->Size = System::Drawing::Size(346, 378);
			this->textBox1->TabIndex = 2;
			// 
			// goButton
			// 
			this->goButton->Location = System::Drawing::Point(6, 28);
			this->goButton->Name = L"goButton";
			this->goButton->Size = System::Drawing::Size(105, 23);
			this->goButton->TabIndex = 3;
			this->goButton->Text = L"Read distance";
			this->goButton->UseVisualStyleBackColor = true;
			this->goButton->Click += gcnew System::EventHandler(this, &Form1::goButton_Click);
			// 
			// groupBox1
			// 
			this->groupBox1->Controls->Add(this->readCard);
			this->groupBox1->Controls->Add(this->goButton);
			this->groupBox1->Location = System::Drawing::Point(12, 21);
			this->groupBox1->Name = L"groupBox1";
			this->groupBox1->Size = System::Drawing::Size(122, 108);
			this->groupBox1->TabIndex = 4;
			this->groupBox1->TabStop = false;
			this->groupBox1->Text = L"Reading";
			this->groupBox1->Enter += gcnew System::EventHandler(this, &Form1::groupBox1_Enter);
			// 
			// readCard
			// 
			this->readCard->Location = System::Drawing::Point(6, 68);
			this->readCard->Name = L"readCard";
			this->readCard->Size = System::Drawing::Size(105, 23);
			this->readCard->TabIndex = 4;
			this->readCard->Text = L"Read Card";
			this->readCard->UseVisualStyleBackColor = true;
			this->readCard->Click += gcnew System::EventHandler(this, &Form1::readCard_Click);
			// 
			// groupBox2
			// 
			this->groupBox2->BackColor = System::Drawing::SystemColors::Info;
			this->groupBox2->Controls->Add(this->comboBox1);
			this->groupBox2->Controls->Add(this->initButton);
			this->groupBox2->Location = System::Drawing::Point(150, 46);
			this->groupBox2->Name = L"groupBox2";
			this->groupBox2->Size = System::Drawing::Size(156, 83);
			this->groupBox2->TabIndex = 5;
			this->groupBox2->TabStop = false;
			this->groupBox2->Text = L"COM init";
			// 
			// groupBox3
			// 
			this->groupBox3->Controls->Add(this->coinsNo);
			this->groupBox3->Controls->Add(this->label1);
			this->groupBox3->Controls->Add(this->rgb);
			this->groupBox3->Controls->Add(this->dispenseGo);
			this->groupBox3->Location = System::Drawing::Point(12, 155);
			this->groupBox3->Name = L"groupBox3";
			this->groupBox3->Size = System::Drawing::Size(294, 101);
			this->groupBox3->TabIndex = 6;
			this->groupBox3->TabStop = false;
			this->groupBox3->Text = L"Dispensing";
			// 
			// label1
			// 
			this->label1->AutoSize = true;
			this->label1->Location = System::Drawing::Point(7, 24);
			this->label1->Name = L"label1";
			this->label1->Size = System::Drawing::Size(84, 13);
			this->label1->TabIndex = 3;
			this->label1->Text = L"Number of coins";
			// 
			// rgb
			// 
			this->rgb->FormattingEnabled = true;
			this->rgb->Items->AddRange(gcnew cli::array< System::Object^  >(3) {L"red", L"green", L"blue"});
			this->rgb->Location = System::Drawing::Point(97, 43);
			this->rgb->Name = L"rgb";
			this->rgb->Size = System::Drawing::Size(191, 21);
			this->rgb->TabIndex = 2;
			// 
			// dispenseGo
			// 
			this->dispenseGo->Location = System::Drawing::Point(7, 70);
			this->dispenseGo->Name = L"dispenseGo";
			this->dispenseGo->Size = System::Drawing::Size(281, 23);
			this->dispenseGo->TabIndex = 1;
			this->dispenseGo->Text = L"Diespense";
			this->dispenseGo->UseVisualStyleBackColor = true;
			this->dispenseGo->Click += gcnew System::EventHandler(this, &Form1::dispenseGo_Click);
			// 
			// coinsNo
			// 
			this->coinsNo->Location = System::Drawing::Point(10, 44);
			this->coinsNo->Name = L"coinsNo";
			this->coinsNo->Size = System::Drawing::Size(81, 20);
			this->coinsNo->TabIndex = 4;
			// 
			// Form1
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 13);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->ClientSize = System::Drawing::Size(690, 411);
			this->Controls->Add(this->groupBox3);
			this->Controls->Add(this->groupBox2);
			this->Controls->Add(this->groupBox1);
			this->Controls->Add(this->textBox1);
			this->Name = L"Form1";
			this->Text = L"Form1";
			this->Load += gcnew System::EventHandler(this, &Form1::Form1_Load);
			this->groupBox1->ResumeLayout(false);
			this->groupBox2->ResumeLayout(false);
			this->groupBox3->ResumeLayout(false);
			this->groupBox3->PerformLayout();
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^  >(this->coinsNo))->EndInit();
			this->ResumeLayout(false);
			this->PerformLayout();

		}
#pragma endregion

int get_reply(void) {

	String^ reply = serialPort1->ReadLine();
	textBox1->AppendText("Reply = " + reply + Environment::NewLine);
	try {
		return Convert::ToSingle(reply);
	}
	catch (FormatException^ fe) {     // string in wrong format for an integer
		MessageBox::Show("The calculations are complete",
		 				 "COM test", 
						 MessageBoxButtons::OKCancel,
						 MessageBoxIcon::Asterisk);
		global_error = FORMAT_ERROR;    // set global error code
		return -1;
	}
}


	private: System::Void Form1_Load(System::Object^  sender, System::EventArgs^  e) {
				 for each (String^ s in SerialPort::GetPortNames()) {
					comboBox1->Items->Add(s);
				}
				global_error = OK;
				Thread::Sleep(1);   // sleep thread for 1 millisecond
			 }
	private: System::Void initButton_Click(System::Object^  sender, System::EventArgs^  e) {
				//
				// set appropriate serial port properties
				//
				serialPort1->PortName = Convert::ToString(comboBox1->SelectedItem);
				serialPort1->BaudRate = 19200;		// set 19200 baud rate
				serialPort1->ReadTimeout = 10000;	// set 10 second timeout on read channel
				
				//
				// Get selected COM port and open. Catch errors and display a message box.
				// Exit the program if error is detected.
				//
				try {
					textBox1->AppendText("Selected COM port = " + Convert::ToString(comboBox1->SelectedItem) + Environment::NewLine);
					serialPort1->Open();
				} catch (...) {    // Catch all exceptions, show message and exit
					textBox1->AppendText("Cannot open selected COM port : do you want to exit?" + Environment::NewLine);
				}

				serialPort1->DiscardInBuffer();		// clear receive buffer
				serialPort1->DiscardOutBuffer();	// clear transmit buffer
				textBox1->AppendText("Opening serial port" + Environment::NewLine);
			 
			 }
private: System::Void goButton_Click(System::Object^  sender, System::EventArgs^  e) {
			String^ command = "d";
			textBox1->AppendText("Reading distance" + Environment::NewLine);
			serialPort1->WriteLine(command);
			textBox1->AppendText("Reading reply" + Environment::NewLine);
			get_reply();
		 }
private: System::Void groupBox1_Enter(System::Object^  sender, System::EventArgs^  e) {
		 }
private: System::Void readCard_Click(System::Object^  sender, System::EventArgs^  e) {
			String^ command = "c";
			textBox1->AppendText("Reading card value" + Environment::NewLine);
			serialPort1->WriteLine(command);
			textBox1->AppendText("Reading reply" + Environment::NewLine);
			get_reply();
		 }
private: System::Void dispenseGo_Click(System::Object^  sender, System::EventArgs^  e) {
			int isError = 0;
			String^ command = "";

			if(Convert::ToString(rgb->SelectedItem == "red")) {
				command = "r "
						+ Convert::ToString(coinsNo->Value);
				textBox1->AppendText("Dispensing " + Convert::ToString(coinsNo->Value) + " red tokens" + Environment::NewLine);
			} else if(Convert::ToString(rgb->SelectedItem == "green")) {
				command = "g "
						+ Convert::ToString(coinsNo->Value);
				textBox1->AppendText("Dispensing " + Convert::ToString(coinsNo->Value) + " green tokens" + Environment::NewLine);
			} else if(Convert::ToString(rgb->SelectedItem == "blue")) {
				command = "b "
						+ Convert::ToString(coinsNo->Value);
				textBox1->AppendText("Dispensing " + Convert::ToString(coinsNo->Value) + " blue tokens" + Environment::NewLine);
			} else {
				isError = 1;
			}

			if(isError != 1){
				serialPort1->WriteLine(command);
				textBox1->AppendText("Reading reply" + Environment::NewLine);
				get_reply();
			}
		 }
};
}



