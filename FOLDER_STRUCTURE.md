# Fewture Homepage - Organized Folder Structure

**Updated:** September 5, 2025  
**Status:** Reorganized for better project management

---

## 📁 **ROOT DIRECTORY**
```
/Users/r/r-code/fewture-homepage/
├── index.html                 # Main application entry point
├── deploy.sh                  # Primary deployment script
├── api-endpoint.txt          # AWS API Gateway endpoint
├── .gitignore                # Git ignore patterns
└── README.md                 # Project overview (if needed)
```

## 📋 **CONFIGURATION FILES**
```
config/
├── deployment.json           # AWS deployment configuration
├── json/                    # All JSON configuration files
│   ├── bucket-policy.json   # S3 bucket policy
│   ├── package.json         # Node.js dependencies
│   ├── package-lock.json    # Dependency lock file
│   ├── yarn.lock           # Yarn lock file
│   └── test-payload.json   # API testing payload
└── yml/                    # YAML and config files
    ├── amplify.yml         # AWS Amplify configuration
    ├── postcss.config.js   # PostCSS configuration
    └── tailwind.config.js  # Tailwind CSS configuration
```

## 📚 **DOCUMENTATION**
```
docs/
├── PROJECT_CLOSURE_SUMMARY.md      # Final project handoff
├── JOSH_SUMMARY.md                 # Executive summary
├── NEXT_STEPS_FOR_JOSH.md          # Action plan
├── ENHANCEMENT_INSTRUCTIONS.md     # Implementation guide
├── REVISED_ENHANCEMENT_PRIORITIES.md # Future roadmap
├── aws_credentials_setup.md        # AWS setup guide
├── aws_setup_guide.md             # AWS deployment guide
├── chatbot_integration_plan.md    # Chatbot implementation
├── comprehensive_setup_guide.md   # Complete setup guide
├── email_draft.md                 # Communication templates
└── quick-deploy.md               # Quick deployment guide
```

## 🔍 **AUDITS & SECURITY**
```
audits/
└── SECURITY_AUDIT.md         # Security compliance verification
```

## 🏗️ **APPLICATION CODE**
```
backend/
├── lambda_function.py        # AWS Lambda function
└── requirements.txt         # Python dependencies

assets/
├── images/
│   ├── Fewture-Studios-Typography.png
│   └── favicon.png
├── models/
│   └── mesh.glb             # 3D model file
└── video/
    ├── IRL Teaser (JUL29).mov
    └── Fewture Media Deck.pdf

src/
└── input.css               # Source CSS (if using build process)

styles/                     # Additional stylesheets (empty)
```

## 🚀 **DEPLOYMENT & SCRIPTS**
```
scripts/
├── create-api-gateway.sh    # API Gateway setup
├── create-iam-role.sh      # IAM role creation
└── deploy-lambda.sh        # Lambda deployment

deploy-package/             # Lightweight deployment package
├── assets/
│   ├── images/
│   └── models/
└── index.html
```

## 🔧 **DEVELOPMENT TOOLS**
```
.cursor/
└── rules/
    └── rules.md            # Project rules and status

.vscode/
└── launch.json            # VS Code debug configuration

.git/                      # Git repository data
```

## 📝 **REFERENCE MATERIALS**
```
ref/
├── ref-001                # Reference materials
├── ref-002
└── ref-003

pi/                        # Additional reference (empty)
```

---

## 🎯 **ORGANIZATION BENEFITS**

### **Improved Structure:**
- **Configuration centralized** in `config/` with logical subfolders
- **Documentation consolidated** in `docs/` for easy access
- **Security audits** separated in `audits/` folder
- **JSON files grouped** together for better management
- **YAML/config files** organized by type

### **Better Maintainability:**
- Clear separation of concerns
- Logical grouping of related files
- Easier navigation for team members
- Consistent file organization patterns

### **Enhanced Workflow:**
- Quick access to deployment configurations
- Centralized documentation for handoffs
- Security compliance tracking
- Streamlined development process

**Total files organized:** 15+ files moved to appropriate directories  
**Structure status:** ✅ Optimized for team collaboration and maintenance
